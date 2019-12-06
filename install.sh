#!/usr/bin/env zsh
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Make the directories we need for installation, if they don't exist.
mkdir -p "$ZSH_CUSTOM"
mkdir -p ".tmp"

# I'm lazy and often forget to do this.
find installers -name '*.zsh' | xargs chmod u+x

# Enable colours.
autoload -U colors && colors

for d in ./installers/*; do
	app=$(basename $d)

	# Start processing the directory.
	echo "[${fg[yellow]}$app${reset_color}]"

	# If the app doesn't define a script for is/isn't installed,
	# don't bother attempting to install it.
	echo "app:     \c"
	if [ ! -f "$d/is_installed.zsh" ]; then
		echo "${fg[green]}none${reset_color}"
	else
		# The return value is 0 for installed, and 1 for not installed.
		$d/is_installed.zsh
		is_installed=$?

		if [[ "$is_installed" -eq 0 ]]; then
			# It's installed, we're done.
			echo "${fg[green]}installed${reset_color}"
		else
			# It's not installed, offer to install by executing the installer script.
			echo "install? [Y/n]: \c"
			read line
			if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
				$d/install.zsh
			fi
		fi
	fi

	# If the app doesn't define aliases,
	# don't bother attempting to copy them.
	echo "aliases: \c"
	if [ ! -f "$d/aliases.zsh" ]; then
		echo "${fg[green]}none${reset_color}"
	elif [ -L "$ZSH_CUSTOM/$app.aliases.zsh" ]; then
		# Aliases are installed, we're done.
		echo "${fg[green]}installed${reset_color}"
	else
		# Aliases not installed, offer to install by symlinking the file.
		echo "install? [Y/n]: \c"
		read line
		if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
			ln -sv "$PWD/$d/aliases.zsh" "$ZSH_CUSTOM/$app.aliases.zsh"
		fi
	fi

	# If the app doesn't define config,
	# don't bother attempting to copy it.
	echo "config:  \c"
	if [ ! -f "$d/config.zsh" ]; then
		echo "${fg[green]}none${reset_color}"
	elif [ -L "$ZSH_CUSTOM/$app.config.zsh" ]; then
		# Config is installed, we're done.
		echo "${fg[green]}installed${reset_color}"
	else
		# Config not installed, offer to install by symlinking the file.
		echo "install? [Y/n]: \c"
		read line
		if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
			ln -sv "$PWD/$d/config.zsh" "$ZSH_CUSTOM/$app.config.zsh"
		fi
	fi

	echo
done

echo "Finished"
