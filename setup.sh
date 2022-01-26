#!/bin/bash
#no op

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


   # ensure .oh-my-zsh is installed
if [[ ! -d "~/.oh-my-zsh" ]]; then
	   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi
brew_dir="/home/linuxbrew/.linuxbrew"
brew_bin_dir=$brew_dir"/bin"
    # install homebrew and homebrew managed stuff
    if [ ! -e $brew_bin_dir"/brew" ]; then
	    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if [ ! -e $brew_bin_dir"/zsh" ]; then
       brew install zsh
    fi

    if [ ! -e $brew_bin_dir"/npm" ]; then
	    brew install npm
    fi

    if [ ! -e $brew_dir"/Cellar/zsh-syntax-highlighting" ]; then
	    brew install zsh-syntax-highlighting
    fi

    if [ ! -e ~/.pyenv ]; then
	    brew install pyenv pyenv-virtualenv
	    pyenv install 3.9.7
    fi

    if [ ! -e $brew_bin_dir"/aws" ]; then
       brew install aws-cli
    fi

    if [ ! -e $brew_bin_dir"/pre-commit" ]; then
       brew install pre-commit
    fi

    if [ ! -e $brew_dir"/Cellar/go" ]; then
       brew install go
    fi

    if [ ! -e $brew_dir"/Cellar/graphviz" ]; then
       brew install graphviz
    fi


# reminders
echo -e "\nDon't forget to set secret things in the following files:"
echo -e "~/.ssh/config\n"

