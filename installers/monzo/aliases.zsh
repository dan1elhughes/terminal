# Load the stock starter-pack if it exists on the machine.
[ -f $HOME/src/github.com/monzo/starter-pack/zshrc ] && source $HOME/src/github.com/monzo/starter-pack/zshrc

# Shorthands for deployment. Usage: `ship <pr or branch name>`
alias shipper="caffeinate -dis shipper"
alias ship="shipper deploy --s101"
alias shipp="shipper deploy --prod"

# Disable CLI emoji to fix spacing bug.
alias £="£ --prompt.emoji=false"

# Shorthand for protobuf generation. Usage: `proto .`
alias proto="../bin/generate_protobufs"

# Shorthand for loading logs for the service in the current directory
logs() {
    SERVICE=`basename $(pwd)`
    slog -fs "$SERVICE"
}

# Watch all files for changes, and run tests when they change.
watchtests() {
    if [ ! -f /usr/local/bin/fd ]; then
        echo "fd not installed"
        return 1
    fi

    fd -e go | entr -c sh -c "go test ./... && echo ✅ || echo ❌"
}
