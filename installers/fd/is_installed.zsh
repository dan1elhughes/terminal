if brew ls --versions fd > /dev/null; then
  exit 0
else
  exit 1
fi
