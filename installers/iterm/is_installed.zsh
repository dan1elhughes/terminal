if brew ls --versions iterm2 --cask > /dev/null; then
  exit 0
else
  exit 1
fi
