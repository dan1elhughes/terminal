alias ccat="pygmentize"
alias less="less -r"
alias mkcd="take"
alias shipper="caffeinate -dis shipper"

up() {
	COUNTER=$1
	while [[ $COUNTER -gt 0 ]]; do
		UP="${UP}../"
		COUNTER=$(( $COUNTER -1 ))
	done
	echo "cd $UP"
	cd $UP
	UP=''
}
