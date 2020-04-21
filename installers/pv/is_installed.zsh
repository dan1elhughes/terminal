if brew ls --versions pv > /dev/null; then
  exit 0
else
  exit 1
fi
