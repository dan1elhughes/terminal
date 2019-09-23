[ -f $HOME/src/github.com/monzo/starter-pack/zshrc ] && source $HOME/src/github.com/monzo/starter-pack/zshrc

alias shipper="caffeinate -dis shipper"
alias ship="shipper deploy --s101"
alias shipp="shipper deploy --prod"
alias £="£ --prompt.emoji=false"
alias proto="../bin/generate_protobufs"

logs() {
    SERVICE=`basename $(pwd)`
    slog -fs "$SERVICE"
}
