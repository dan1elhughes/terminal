export ZSH="$HOME/.oh-my-zsh"

autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:path color white

plugins=( git osx z )

source $ZSH/oh-my-zsh.sh
