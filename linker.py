"""
This script is to put links to the dotfile files where they are expected to be.
"""
import os

# Set dirs
dotfile_dir  = os.path.dirname(__file__)
print(dotfile_dir)
home_dir = os.path.expanduser('~')
print(home_dir)

# Set lists of (src, dest) for symlinks and hardlink
TODO: make a function that does both types of links
symlinks = [
        {'link_type': 'sym', 'src': f'{dotfile_dir}/vimrc', 'dest': f'{home_dir}/.config/nvim/init.vim'}
]
hardlinks= [
        {'link_type': 'hard', 'src': f'{dotfile_dir}/gitconfig', 'dest': f'{home_dir}/.gitconfig'},
    {'link_type': 'hard', 'src': f'{dotfile_dir}/zshrc', 'dest': f'{home_dir}/.zshrc'}
]
for symlink in symlinks:
    try:
        # Remove the old file if it is there
        os.remove(symlink['dest'])
    except:
        pass
    os.symlink(symlink['src'], symlink['dest'])
    print (f"symlink created: {symlink['dest']}")
for hardlink in hardlinks:
    try:
        os.remove(hardlink['dest'])
    except:
        pass
    os.link(hardlink['src'], hardlink['dest'])
    print (f"hardlink created: {hardlink['dest']}")
