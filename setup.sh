#!/bin/bash

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd  )"

# symlink files from within ./common into their correct places within ~/
echo -e "installing common dotfiles\n"
for item in `ls -a $DIR/common/`
do
    echo $item
    ln -snf $DIR/common/$item ~
done

# clone and install vimfiles
echo -e "installing vimfiles\n"
git clone https://github.com/stricklin/vimfiles.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
# Pull most recent version of vim-plug plugin manager
curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > ~/.vim/autoload/plug.vim
vim +PlugInstall +qall

echo -e "determining OS and distro, then installing related dotfiles\n"
if [ "$(uname)" == "Darwin" ]; then
    # ensure .oh-my-zsh is installed
    if [[ ! -d "~/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

        # install powerline patched fonts for use in iTerm
        sh -c "$(git clone https://github.com/powerline/fonts.git --depth=1 ~/dotfiles/mac/fonts)"
        sh -c "$(~/dotfiles/mac/fonts/install.sh && rm -rf ~/dotfiles/mac/fonts/)"
    fi

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

    # copy karabiner config in place since the symlink gets overwritten when opening Karabiner-Elements 
    cp $DIR/mac/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json

    # symlink files from within ./mac/ to their correct location
    echo -e "installing dotfiles for MacOS"
    for item in `ls -a $DIR/mac/`
    do
        echo $item
        ln -snf $DIR/mac/$item ~
    done

fi

# reminders
echo -e "\nDon't forget to set secret things in the following files:"
echo -e "~/.ssh/config\n"
