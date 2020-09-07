if brew ls --versions tree > /dev/null; then
  exit 0
else
  exit 1
fi
