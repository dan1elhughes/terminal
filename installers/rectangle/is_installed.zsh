if brew ls --versions rectangle --cask > /dev/null; then
  exit 0
else
  exit 1
fi
