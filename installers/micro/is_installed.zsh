if brew ls --versions micro > /dev/null; then
  exit 0
else
  exit 1
fi
