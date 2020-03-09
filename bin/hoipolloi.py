#!/usr/bin/env python3

import os
import sys
import time
import json
from string import Template
from pathlib import Path
from subprocess import PIPE, Popen, run

HOI_POLLOI_DIR = Path('/tmp/hoipolloi')
CONFIG_DIR = Path('~/.hoipolloi').expanduser()


def update_symlink(symlink, target):
    new_link = symlink.with_suffix('.' + str(time.time()).replace('.', ''))
    new_link.symlink_to(target)
    new_link.replace(symlink)
    new_link


def create_symlink(symlink, target):
    symlink.symlink_to(target)


def set_symlink(symlink, target):
    fn = update_symlink if symlink.is_symlink() else create_symlink
    fn(symlink, target)


def set_hoi_polloi_user(username):
    set_symlink(HOI_POLLOI_DIR / 'links', HOI_POLLOI_DIR / username)


def make_user_dir(username):
    (HOI_POLLOI_DIR / username).mkdir(parents=True, exist_ok=True)


def set_ssh_agent(username, auth_sock):
    make_user_dir(username)
    set_symlink(HOI_POLLOI_DIR / username / 'ssh_auth_sock', Path(auth_sock))


def environ_to_dict(data):
    return dict([entry.split('=', 1) for entry in data.split('\00') if entry])


class TmuxClient:
    def __init__(self, pid, name, read_only):
        self.pid = pid
        self.name = name
        self.read_only = bool(int(read_only))

    def hoi_polloi_user(self):
        return environ_to_dict(
            open('/proc/{}/environ'.format(self.pid)).read()
        ).get('HOI_POLLOI_USER', 'default')

    @classmethod
    def tmux_list_clients(cls):
        data_format = '#{client_pid} #{client_name} #{client_readonly}'
        list_clients = run(
            ['byobu', 'list-clients', '-F', data_format, '-t', 'hoipolloi'],
            stdout=PIPE
        )
        return [cls(*l.split()) for l in str(list_clients.stdout, 'ascii').split('\n') if l]

    def toggle_read_only(self):
        run('byobu switch-client -c {} -r'.format(self.name).split())

    @classmethod
    def handoff_to(cls, username):
        for client in cls.tmux_list_clients():
            TmuxClient.evaluate_handoff_for_client(client, username)

    @staticmethod
    def evaluate_handoff_for_client(client, username):
        hoi_polloi_user = client.hoi_polloi_user()
        if username == hoi_polloi_user and client.read_only is True:
            client.toggle_read_only()
        elif username != hoi_polloi_user and client.read_only is False:
            client.toggle_read_only()

    @classmethod
    def open_wide(cls):
        for client in cls.tmux_list_clients():
            if client.read_only is True:
                client.toggle_read_only()


def get_session(username):
    list_sessions = run('byobu list-sessions'.split(), stdout=PIPE)
    lines = str(list_sessions.stdout, 'ascii').split('\n')
    running = any([l.startswith('hoipolloi') for l in lines])
    if running:
        read_only = any(c.read_only is False for c in TmuxClient.tmux_list_clients())
        read_only_flag = '-r' if read_only else ''
        os.execv('/usr/bin/byobu', 'byobu attach {} -t hoipolloi'.format(read_only_flag).split())
    else:
        os.environ['SSH_AUTH_SOCK'] = str(HOI_POLLOI_DIR / 'links' / 'ssh_auth_sock')
        set_hoi_polloi_user(username)
        os.execv('/usr/bin/byobu', 'byobu new-session -s hoipolloi bash -l'.split())


def client(cfg, username=os.environ['USER'], servername=None):
    ssh_template = 'ssh -T -A {}'.format(servername)
    ssh = Popen(ssh_template.split(), stdin=PIPE, stdout=PIPE)
    ssh.stdin.write(b'echo HOI_POLLOI_SSH_AUTH_SOCK: $SSH_AUTH_SOCK\n')
    ssh.stdin.flush()
    while True:
        line = str(ssh.stdout.readline(), 'utf8')
        if 'HOI_POLLOI_SSH_AUTH_SOCK:' in line:
            ssh_auth_sock = line.split()[1]
            print(ssh_auth_sock)
            break

    mosh_template = 'mosh {} -- hoipolloi server --username {} --auth-sock {}'
    try:
        run(mosh_template.format(servername, username, ssh_auth_sock).split())
    except Exception:
        pass
    ssh.terminate()


def expand_templates(cfg, username):
    fullname = cfg.get('fullnames', {}).get(username, username)

    template_dir = CONFIG_DIR / 'templates'
    if template_dir.is_dir():
        template_paths = template_dir.glob('*.tmpl')
    else:
        template_paths = []

    for template_path in template_paths:
        template = Template(template_path.open().read())
        out_path = HOI_POLLOI_DIR / username / template_path.stem
        out_path.open('w').write(template.substitute(username=username, fullname=fullname))


def place_user_files(cfg, username):
    file_dir = CONFIG_DIR / 'files' / username
    for file_path in file_dir.glob('*'):
        out_path = HOI_POLLOI_DIR / username / file_path.name
        out_path.open('w').write(file_path.open().read())


def server(cfg, username=None, auth_sock=None):
    HOI_POLLOI_DIR.mkdir(parents=True, exist_ok=True)
    set_ssh_agent(username, auth_sock)
    expand_templates(cfg, username)
    place_user_files(cfg, username)
    os.environ['HOI_POLLOI_USER'] = username
    get_session(username)


def switch(cfg, username, **kw):
    set_hoi_polloi_user(username)
    TmuxClient.handoff_to(username)


def users(cfg):
    for client in TmuxClient.tmux_list_clients():
        print(client.hoi_polloi_user(), 'ro' if client.read_only else 'rw')


def riot(cfg):
    TmuxClient.open_wide()


def wrap(cfg, username, *cmd_args):
    os.environ.update(cfg.get('environ', {}).get(username, {}))
    os.execv(cmd_args[0], cmd_args)


modes = {f.__name__: f for f in [client, server, switch, users, riot, wrap]}


def get_config():
    config_path = CONFIG_DIR / 'config'
    if config_path.is_file():
        data = json.load(open(config_path))
    else:
        data = {}
    return data


def hoipolloi():
    cfg = get_config()
    paired_cmd_tokens = list(zip([''] + sys.argv[1:-1], sys.argv[1:]))
    flags = {a[2:].replace('-', '_'): b for a, b in paired_cmd_tokens if a.startswith('--')}
    args = [b for a, b in paired_cmd_tokens if not a.startswith('--') and not b.startswith('--')]
    modes[args[0]](cfg, *args[1:], **flags)


if __name__ == '__main__':
    hoipolloi()
