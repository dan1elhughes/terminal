if brew ls --versions github/gh/gh > /dev/null; then
  exit 0
else
  exit 1
fi
