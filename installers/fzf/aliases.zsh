function fedit() {
    eval $EDITOR "$(rg --files | fzf)"
}
