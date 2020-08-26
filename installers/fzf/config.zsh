# Default to fd instead of `find`, as it's a lot faster.
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'

# Keep the colours!
export FZF_DEFAULT_OPTS="--ansi"
