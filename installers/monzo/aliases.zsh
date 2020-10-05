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

# Run all the codegen for any changed services.
gen() {
    GIT_BASE_BRANCH=${GIT_BASE_BRANCH:-master}
    CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
    WEAREDEV="$GOPATH/src/github.com/monzo/wearedev"
    LOGFILE="${TMPDIR}gen_log.txt"

    echo "" > $LOGFILE

    if [[ $CURRENT_BRANCH == "$GIT_BASE_BRANCH" ]]; then
        # We're on master
        if git rev-list --merges 'HEAD~1..HEAD' | grep -q .; then
            # HEAD is a merge commit; find the first parent, which is the older
            # base of the merge.
            merge_base=$(git cat-file commit HEAD | grep -m 1 '^parent ' | cut -d' ' -f2)
        else
            # Otherwise we assume HEAD is a squashed branch, and it contains
            # all the changes in that one commit.
            merge_base='HEAD~1'
        fi
    else
        # We're in a PR; figure out the common ancestor with master
        merge_base=$(git merge-base origin/"$GIT_BASE_BRANCH" HEAD)
    fi

    changed=()
    while IFS= read -r line; do
        changed+=( "$line" )
    done < <(
        git diff-tree \
            --diff-filter=ACM --name-only \
            -r "${merge_base}..HEAD"
        )

    if [ ${#changed[@]} -eq 0 ]; then
        echo "👌 No changes matching file extensions for formatting were found."
        exit 0
    fi

    dirs=()
    for file in "${changed[@]}"; do
        dirs+=(`echo "$file" | cut -d"/" -f1`)
    done

    for dir in $(printf "%s\n" "${dirs[@]}" | sort -u); do
        if [ ! -d "$WEAREDEV/$dir" ]; then
            # Might be a file in the root of the repo.
            echo "Skipping $WEAREDEV/$dir" > $LOGFILE
            continue
        fi

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
            go run scripts/gqlgen.go
            echo "✅" | tee -a $LOGFILE
        fi
    done

    echo "\nLogs: $LOGFILE"
}
