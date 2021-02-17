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

# Run all the codegen for any changed services.
gen() {
    WEAREDEV="$GOPATH/src/github.com/monzo/wearedev"
    LOGFILE="${TMPDIR}gen_log.txt"

    echo "" > $LOGFILE

	if [ "$#" -eq 0 ]; then
		echo "Usage: gen <dir>"
        return 1
	fi

    # Required on OSX:
    # brew install coreutils
    dir=$(basename `realpath $1`)

    # MANIFESTS #
    echo -ne "$dir: manifests " | tee -a $LOGFILE
    $WEAREDEV/bin/generate_manifests "$WEAREDEV/$dir" > $LOGFILE
    echo "✅" | tee -a $LOGFILE

    # RPCMAP #
    echo -ne "$dir: rpcmap " | tee -a $LOGFILE
    go run "$WEAREDEV/tools/rpcmap/cmd/rpcmap" -generate "$WEAREDEV/$dir" > $LOGFILE
    echo "✅" | tee -a $LOGFILE

    # PROTOBUFS #
    echo -ne "$dir: protobufs " | tee -a $LOGFILE
    if [ ! -d "$WEAREDEV/$dir/proto" ]; then
        echo "⏭" | tee -a $LOGFILE
    else
        $WEAREDEV/bin/generate_protobufs "$WEAREDEV/$dir" > $LOGFILE
        echo "✅" | tee -a $LOGFILE
    fi

    # GQLGEN #
    echo -ne "$dir: gqlgen " | tee -a $LOGFILE
    if [ ! -d "$WEAREDEV/$dir/graphql" ]; then
        echo "⏭" | tee -a $LOGFILE
    else
        builtin cd "$WEAREDEV/$dir/graphql" > $LOGFILE
        go run scripts/gqlgen.go > $LOGFILE
        builtin cd "-" > $LOGFILE
        echo "✅" | tee -a $LOGFILE
    fi

    echo "\nLogs: $LOGFILE"
}

# Pipe into this function to strip newlines. Useful for editing JSON in a text
# editor before using it in the CLI, for example:
# pbpaste | stripnewlines | pbcopy
stripnewlines() {
    while read data; do
        echo $data | tr -d '\n' | tr -s ' '
    done
}
