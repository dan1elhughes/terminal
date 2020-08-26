# Find and edit.
function fedit() {
    selected=$(rg --files | fzf --preview 'bat --style numbers,changes --color=always --line-range :$LINES {}')
    [ -z "$selected" ] && exit
    eval $EDITOR "$selected"
}

# Find and checkout git branch.
function fcheckout() {
    branches=$(git branch --format='%(refname:short)')
    selected=$(echo $branches | fzf --preview 'git log --oneline master..{}')
    [ -z "$selected" ] && exit
    git checkout "$selected"
}
