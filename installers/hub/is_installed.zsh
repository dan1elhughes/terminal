if brew ls --versions hub > /dev/null; then
  exit 0
else
  exit 1
fi
