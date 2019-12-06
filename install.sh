#!/usr/bin/env zsh
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

mkdir -p "$ZSH_CUSTOM"
mkdir -p ".tmp"

# Lazy mode
find installers -name '*.zsh' | xargs chmod u+x

for d in ./installers/*; do
	app=$(basename $d)
	echo "[$app]"

	echo "App: \c"
	if [ ! -f "$d/is_installed.zsh" ]; then
		echo "none"
	else
		$d/is_installed.zsh
		is_installed=$?

		if [[ "$is_installed" -eq 0 ]]; then
			echo "installed"
		else
			echo "install? [Y/n]: \c"
			read line
			if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
				$d/install.zsh
			fi
		fi
	fi

	echo "Aliases: \c"
	if [ ! -f "$d/aliases.zsh" ]; then
		echo "none"
	elif [ -L "$ZSH_CUSTOM/$app.aliases.zsh" ]; then
		echo "installed"
	else
		echo "install? [Y/n]: \c"
		read line
		if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
			ln -sv "$PWD/$d/aliases.zsh" "$ZSH_CUSTOM/$app.aliases.zsh"
		fi
	fi

	echo "Config: \c"
	if [ ! -f "$d/config.zsh" ]; then
		echo "none"
	elif [ -L "$ZSH_CUSTOM/$app.config.zsh" ]; then
		echo "installed"
	else
		echo "install? [Y/n]: \c"
		read line
		if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
			ln -sv "$PWD/$d/config.zsh" "$ZSH_CUSTOM/$app.config.zsh"
		fi
	fi

	echo
done

echo "Finished"
