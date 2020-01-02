curl -sSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/kubectl/kubectl.plugin.zsh -o .tmp/kubectl.plugin.zsh
ln -sfv $PWD/.tmp/kubectl.plugin.zsh "$HOME/.oh-my-zsh/custom/kubectl.plugin.zsh"
