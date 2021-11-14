#!/bin/bash
# ---------------------------------------------------------------------------------------------------------
# W2L                                                                                                      
# This script sets up a remote desktop protocol (RDP) server persistently.
# The login info is printed after setup and need to be inserted in Windows 'Remote Desktop Connection' app.
# ---------------------------------------------------------------------------------------------------------
function caddy () {
    local pid=$!
    declare -a ani=("   🛒" "  🛒 " " 🛒  " "🛒   " "     ")
    declare -i id
    id=0
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        id=$id%5
        #echo "$id ${ani[$id]}"
        printf "[\033[1;35m${ani[$id]}\033[0m]: $1\r"
        id=$((id+1))
        sleep .15
    done
}
function highlight () {
	printf "\n\t\033[1;33m$1\033[1;35m\n"; sleep 1
}
function install () {
    eval "sudo apt install $1 -y" &> /dev/null & caddy "installing $1"
}
highlight "W2L"
highlight "Installing Dependencies ..."
sudo apt-get update &&
install ssh &&
install xrdp &&
highlight "Enable to start after reboot and run the remote desktop sharing server ..."
sudo systemctl enable --now xrdp
highlight "Set TCP port ..."
sudo ufw allow from any to any port 3389 proto tcp
highlight "done."
highlight "Connect after rebooting via Windows RDP:\nUser: $(whoami)\nHost: $(hostname)"
highlight "Reboot system now [recommended]? (y/n)"
read qreboot
if [ $qreboot == "y" ]; then
	for i in 5 4 3 2 1
	do
		printf "Reboot in $i seconds ...\r"; sleep 1
	done
	sudo reboot
fi
highlight "W2L setup completed."