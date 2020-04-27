if brew ls --versions rectangle > /dev/null; then
  exit 0
else
  exit 1
fi
