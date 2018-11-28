#!/usr/bin/env bash
OUTPUT="$HOME/.oh-my-zsh/custom/"

for f in ./config/*; do
	cp -v "$f" "$OUTPUT"
done
