function fedit() {
    eval $EDITOR "$(rg --files | fzf --preview 'bat --style numbers,changes --color=always {}')"
}
