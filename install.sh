#!/usr/bin/env zsh
OUTPUT="$HOME/.oh-my-zsh/custom/"

cp -v "./zshrc" "$OUTPUT../../.zshrc"
for f in ./config/*; do
	cp -v "$f" "$OUTPUT"
done

. ~/.zshrc
