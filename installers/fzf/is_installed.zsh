if brew ls --versions fzf > /dev/null; then
  exit 0
else
  exit 1
fi
