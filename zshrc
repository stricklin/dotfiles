#a If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/r633474/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="clean"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
  history-substring-search
  #kubectl
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='vim'
# fi
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# turn on vim emulation, turned off because its fucky
bindkey -v
bindkey "^R" history-incremental-search-backward
export KEYTIMEOUT=1
# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

# define right prompt, regardless of whether the theme defined it
#RPS1='$(vi_mode_prompt_info)'
#RPS2=$RPS1

# work proxy stuff

containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}
 
#REGENCE_PROXY="http://utrgproxywest.regence.com:8080"
#DO_NOT_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com,*.healthsparq.com,*.regence.com,*.healthsparq.net"
#REGENCE_EXT_IP=("199.79.222.119")
#external_ip="$(curl -s http://ipinfo.io/ip)"
##Location-specific settings
#if containsElement "${external_ip}" "${REGENCE_EXT_IP[@]}"; then
    #export HTTP_PROXY="${REGENCE_PROXY}"
    #export http_proxy="${REGENCE_PROXY}"
    #export https_proxy="${REGENCE_PROXY}"
    #export HTTPS_proxy="${REGENCE_PROXY}"
    #export ftp_proxy="${REGENCE_PROXY}"
    #export FTP_PROXY="${REGENCE_PROXY}"
    #export no_proxy="${DO_NOT_PROXY}"
    #export NO_PROXY="${DO_NOT_PROXY}"
#else
    #unset http_proxy
    #unset HTTP_PROXY
    #unset https_proxy
    #unset HTTPS_PROXY
    #unset ftp_proxy
    #unset FTP_PROXY
    #unset no_proxy
    #unset NO_PROXY
#fi

# Enviroment variables needed for MacPorts
export PATH=/Users/r633474/Library/Python/3.7/bin:/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

# Set JAVA_HOME
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home

# Set Path
export PATH="/usr/local/sbin:$PATH"

# Set config dir
export CONFIG_DIR="~/dotfiles"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias gs='git status'
alias ga='git add -A'
alias gc='ga && git commit -m'
alias gp='gc "auto commit" && git push'
alias zshconfig="cd $CONFIG_DIR && nvim ./zshrc && source ./zshrc && gp"
#TODO THIS IS WHERE YOU LEFT OFF
alias ohmyzsh="nvim ~/.oh-my-zsh && source ~/.oh-my-zsh"
alias nvimconfig="nvim ~/.config/nvim/init.vim && source ~./config/nvim/init.vim"
alias todo="nvim ~/work_journal/current"
alias tolearn="nvim ~/learning_journal/current"
alias pwa="nvim ~/pwa/notes"
alias scratch='nvim ~/scratch/`date +"%Y-%m-%d`.txt'
alias gi='gi() { for arg in $@; do echo $arg >> ./.gitignore; done }; gi'

