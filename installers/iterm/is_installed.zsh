if brew cask ls --versions iterm2 > /dev/null; then
  exit 0
else
  exit 1
fi
