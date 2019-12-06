#!/bin/bash
app=$1
mkdir -p "installers/$app" && touch installers/$app/{aliases,install,is_installed,config}.zsh
