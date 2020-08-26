function fedit() {
    eval $EDITOR "$(rg --files | fzf --preview 'bat --style numbers,changes --color=always {}')"
}

# TODO: z not found
# function fz() {
#     z | awk '{print $2}' | fzf --preview 'ls {}'
# }
