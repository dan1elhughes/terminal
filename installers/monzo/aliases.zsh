# Load the stock starter-pack if it exists on the machine.
[ -f $HOME/src/github.com/monzo/starter-pack/zshrc ] && source $HOME/src/github.com/monzo/starter-pack/zshrc

# Shorthands for deployment. Usage: `ship <pr or branch name>`
alias shipper="caffeinate -dis shipper"
alias ship="shipper deploy --s101"
alias shipp="shipper deploy --prod"

letsgo() {
    pr="$1"
    waitmerge "$pr" && shippp "$pr"
}

shippp() {
    pr="$1"
    ship "$pr" && shipp "$pr"
}

# Watch the rollout of pods.
watchpods() {
    dir=$(basename `pwd`)
    watch kubectl get pods -l app="io.gmon.$dir"
}

y() {
    app="$1"
    yarn && yarn workspace "@mondough/$1" start
}

# Disable CLI emoji to fix spacing bug.
alias £="£ --prompt.emoji=false"

# Shorthand for protobuf generation. Usage: `proto .`
alias proto="../bin/generate_protobufs"

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
        GO111MODULE=auto go run scripts/gqlgen.go > $LOGFILE
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
