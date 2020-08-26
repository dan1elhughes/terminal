# Find and edit.
function fedit() {
    selected=$(rg --files | fzf --preview 'bat --style numbers,changes --color=always --line-range :$LINES {}')
    [ -z "$selected" ] && exit
    eval $EDITOR "$selected"
}

# TODO: z not found
# function fz() {
#     z | awk '{print $2}' | fzf --preview 'ls {}'
# }
