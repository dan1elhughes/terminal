#!/usr/bin/env zsh
ZSHFOLDER="$HOME/.oh-my-zsh"

cp -v "./zshrc" "$HOME/.zshrc"
for f in ./config/*; do
	cp -rv "$f" "$ZSHFOLDER/custom"
done

. ~/.zshrc
