if brew ls --versions n > /dev/null; then
  exit 0
else
  exit 1
fi
