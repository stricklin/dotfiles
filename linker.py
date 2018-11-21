"""
This script is to put links to the dotfile files where they are expected to be.
"""
import os

# Set dirs
dotfile_dir  = os.path.dirname(__file__)
print(dotfile_dir)
home_dir = os.path.expanduser('~')
print(home_dir)

links = [
        ('symlink', f'{dotfile_dir}/vimrc', f'{home_dir}/.config/nvim/init.vim'},
        ('hardlink', f'{dotfile_dir}/gitconfig', f'{home_dir}/.gitconfig'},
        ('hardlink', f'{dotfile_dir}/zshrc', f'{home_dir}/.zshrc'}
        ]
for 

def make_link(link_type, src, dest):

    try:
        # Remove the old file if it is there
        os.remove(dest)
    except:
        pass
    if link_type is 'symlink':
        os.symlink(src, dest)
    else:
        os.link(src, dest)
    print (f'{link_type} created: {dest}')

