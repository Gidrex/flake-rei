#!/bin/bash

a="⬜"
b="🟪"
c="🟪" 

second=$(date +%S)

if [ $((second % 3)) -eq 0 ]; then
  echo -e "$a$b$c "
elif [ $((second % 3)) -eq 1 ]; then
  echo -e "$c$a$b "
else
  echo -e "$b$c$a "
fi
