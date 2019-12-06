# Don't fetch git remote status in zsh prompt.
export PURE_GIT_PULL=0

autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:path color white
