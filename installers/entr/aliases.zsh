# Watch all go files for changes, and run tests when they change.
watchtests() {
    if [ ! -f /usr/local/bin/fd ]; then
        echo "fd not installed"
    else
        fd -e go | entr -c go test ./...
    fi
}
