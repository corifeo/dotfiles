#!/bin/sh

PWD=`pwd`

for file in *; do
  if [ "$file" != "setup.sh" ]; then
    ln -fs $PWD/$file ~/.$file
  fi
done

