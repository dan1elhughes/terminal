#!/bin/bash

# Read the app from the command line flag
app=$1

# Create the directory
mkdir -p "installers/$app"

# Create the standard files
touch installers/$app/{aliases,install,is_installed,config}.zsh

# All of the .zsh files should be executable
find "installers/$app" -name '*.zsh' | xargs chmod u+x

