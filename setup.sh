#!/bin/bash
#no op

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd  )"

# symlink files from within ./common into their correct places within ~/
echo -e "installing common dotfiles\n"
for config_file in `ls -a $DIR/common/`
do
	echo $config_file
	ln -snf $DIR/common/$config_file ~/$config_file
done



if which apt; then
# if debian-ish linux
      # Determine if ARM architecture
      IS_ARM="$(dpkg --print-architecture | grep arm | wc -l)"

      if [ ! "$(which zsh)" ]; then
         sudo apt install zsh gh unzip -y
      fi
      
      # Ensure .oh-my-zsh is installed
      if [ ! -e "~/.oh-my-zsh" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
            https://github.com/fabiokiatkowski/exercism.plugin.zsh.git
      fi

      if [ ! "$(which npm)" ]; then
         sudo apt install npm -y
      fi

      if [ ! "$(which pyenv)" ]; then
         git clone https://github.com/pyenv/pyenv.git ~/.pyenv
         PYENVGLOBAL="3.12.4"
         pyenv install 3.11.9
         pyenv install 3.12.4
         pyenv global $PYENVGLOBAL
      fi


      if [ ! -e "/usr/local/bin/aws" ]; then
         if [$IS_ARM -eq 1 ]; then
            curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
         else
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
         fi
         unzip awscliv2.zip
         sudo ./aws/install
      fi

      if [ ! "$(which pre-commit)" ]; then
         pip install pre-commit
      fi

      if [ ! "$(xclip)" ]; then
         sudp apt install xclip
      fi

      if [ ! "$(which go)" ]; then
         # WARNING: if installing over old go, delete old go first
         if [ $IS_ARM -eq 1 ]; then
            wget "https://go.dev/dl/go1.22.5.linux-arm64.tar.gz"
            rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.5.linux-arm64.tar.gz
         else
            wget "https://go.dev/dl/go1.22.5.linux-amd64.tar.gz"
            rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
         fi
         curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.59.1
      fi


else
# If not debian, hopefully brew works
   echo  "\nnon-debian setup hasn\'t been ran in awhile, it\'s commented out to prevent oopsies\n"

   # brew_dir="/home/linuxbrew/.linuxbrew"
   # brew_bin_dir=$brew_dir"/bin"
   #    # install homebrew and homebrew managed stuff
   #    if [ ! -d $brew_bin_dir"/brew" ]; then
   #       /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   #    fi
   #    if [ ! -e $brew_bin_dir"/zsh" ]; then
   #       brew install zsh
   #    fi

   #    if [ ! -e $brew_bin_dir"/npm" ]; then
   #       brew install npm
   #    fi

   #    if [ ! -e ~/.pyenv ]; then
   #       brew install pyenv pyenv-virtualenv
   #       pyenv install 3.9.7
   #    fi

   #    if [ ! -e $brew_bin_dir"/aws" ]; then
   #       brew install awscli
   #    fi

   #    if [ ! -e $brew_bin_dir"/pre-commit" ]; then
   #       brew install pre-commit
   #    fi

   #    if [ ! -e $brew_dir"/Cellar/go" ]; then
   #       brew install go
   #    fi

   #    if [ ! -e $brew_dir"/Cellar/graphviz" ]; then
   #       brew install graphviz
   #    fi
fi

# clone and install vimfiles
echo -e "installing vimfiles\n"
if [ ! -e ~/.vim ]; then
	git clone https://github.com/stricklin/vimfiles.git ~/.vim
else
	pushd ~/.vim
   git pull
   popd
   # Pull most recent version of vim-plug plugin manager
   curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > ~/.vim/autoload/plug.vim
   vim +PlugInstall +qall
fi
ln -s ~/.vim/vimrc ~/.vimrc

# reminders
echo -e "\nDon't forget to set secret things in the following files:"
echo -e "\n~/.ssh/config"

