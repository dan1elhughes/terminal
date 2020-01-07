if brew ls --versions ripgrep > /dev/null; then
  exit 0
else
  exit 1
fi
