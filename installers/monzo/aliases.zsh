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

# Send the current branch into staging or prod.
#
# Deploy to staging:    yeet
# Deploy to prod:       yeet prod
yeet() {
	if [ "$#" -eq 0 ]; then
        env="s101"
	else
        env="$1"
	fi

    branch=`git rev-parse --abbrev-ref HEAD`
    shipper deploy --environment $env $branch
}
