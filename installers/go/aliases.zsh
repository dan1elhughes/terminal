# Watch all .go files for changes, and run tests when they change.
watchtests() {
    if [ ! -f /usr/local/bin/fd ]; then
        echo "fd not installed"
        return 1
    fi

    fd -e go | entr -c sh -c "go test ./... && echo ✅ || echo ❌"
}

# Watch all .go files for changes, and build when they change.
watchbuild() {
    if [ ! -f /usr/local/bin/fd ]; then
        echo "fd not installed"
        return 1
    fi

    fd -e go | entr -c sh -c "go build ./... && echo ✅ || echo ❌"
}
