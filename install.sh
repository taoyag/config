#!/bin/bash

src=`echo $(cd $(dirname $0);pwd)`
echo $src

# bin
mkdir -p $HOME/bin
for f in bin/*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    echo "$src/$f"
    ln -sf "$src/$f" "$HOME/bin/"`basename "$f"`
done
echo '----'

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    [[ "$f" == ".gitmodules" ]] && continue
    [[ "$f" == "..gitignore.un~" ]] && continue
    [[ "$f" == "..zshrc.un~" ]] && continue

    echo "$src/$f"
    ln -sf "$src/$f" "$HOME/$f"
done
