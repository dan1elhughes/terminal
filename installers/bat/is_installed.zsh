if brew ls --versions bat > /dev/null; then
  exit 0
else
  exit 1
fi
