#!/bin/bash

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd  )"

# symlink files from within ./common into their correct places within ~/
echo -e "installing common dotfiles\n"
for item in `ls -a $DIR/common/`
do
   echo $item
   ln -snf $DIR/common/$item ~
done

# symlink files from within ./bin into their correct places within /usr/local/bin
echo -e "installing binaries\n"
for item in `ls -a $DIR/bin/`
do
   echo $item
   ln -snf $DIR/bin/$item /usr/local/bin
done

# clone and install vimfiles
echo -e "installing vimfiles\n"
if [ ! -e ~/.vim ]
then
   git clone https://github.com/stricklin/vimfiles.git ~/.vim
else
   cd ~/.vim && git pull && cd $DIR
fi
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

    # install homebrew and homebrew managed stuff
    if [ ! -e /usr/local/bin/brew ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    if [ ! -e /usr/local/bin/mvn ]; then
       brew install maven
    fi

    if [ ! -e /usr/local/bin/npm ]; then
       brew install npm
    fi

    if [ ! -e /usr/local/bin/mosh ]; then
       brew install mosh
    fi

    if [ ! -e /usr/local/bin/watch ]; then
       brew install watch
    fi

    if [ ! -e /usr/local/bin/tree ]; then
       brew install tree
    fi

    if [ ! -e /usr/local/bin/gpg ]; then
       brew install gpg
    fi

    if [ ! -e /usr/local/share/zsh-syntax-highlighting ]; then
       brew install zsh-syntax-highlighting
    fi

    if [ ! -e /usr/local/Cellar/magic-wormhole ]; then
       brew install magic-wormhole
    fi

    if [ ! -e /usr/local/bin/python3 ]; then
       brew install python3
       ln /usr/local/bin/python3 /usr/local/bin/python
       ln /usr/local/bin/pip3 /usr/local/bin/pip
       pip install virtualenvwrapper magic-wormhole awscli black isort flake8 pipenv
    fi



fi

# reminders
echo -e "\nDon't forget to set secret things in the following files:"
echo -e "~/.ssh/config\n"

