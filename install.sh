#!/usr/bin/env zsh
ZSHFOLDER="$HOME/.oh-my-zsh"

echo Installing ZSH theme...
npm install --global pure-prompt

cp -v "./zshrc" "$HOME/.zshrc"
for f in ./config/*; do
	cp -rv "$f" "$ZSHFOLDER/custom"
done

. ~/.zshrc
