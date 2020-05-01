#!/bin/bash
# menu shell script
## ----------------------------------
# Define variables
# ----------------------------------
EDITOR=nano
RED='\033[0;41;30m'
STD='\033[0;0;39m'

## -----------------------------------
# Functions
## ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

#setup and start docker environment macos
setup_start_env_macos(){
	set_ip_macos
        setup_start_docker
	pause
}

#setup and start docker environment linux RHEL 7.x
setup_start_env_linux(){
        set_ip_linux
        setup_start_docker
        pause
}

# setup ip in macos
set_ip_macos(){
        export OWLVEY_HOST=$(ifconfig en0 | grep "inet " | awk -F'[: ]+' '{ print $2 }') 
        echo " Setup ip in environment: ${OWLVEY_HOST} "
}

# setup ip in linux RHEL 7.x
set_ip_linux(){
        export OWLVEY_HOST=$(ifconfig ens160 | grep "inet " | awk -F'[: ]+' '{ print $3 }')
        echo " Setup ip in environment: ${OWLVEY_HOST} "
}

# setup and start environment with docker()
setup_start_docker(){
	docker-compose down
        docker-compose pull
        docker-compose up -d
}

# function to display menus
show_menus() {
        clear
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "  OWLVEY - SRE : Chooses the network interface  "
        echo "~~~~~~~~~~~~~~~~~~~~~"
        echo "1. macos_en0"
	echo "2. linux_ens160"
        echo "3. Exit"
}
# Read input action in terminal and execute
# Invoke setup_start_env() function when the user choose 1 in the menu.
# Exit of the menu when the user choose 2 in the menu
read_options(){
        local choice
        read -p "Enter choice [ 1 - 3] " choice
        case $choice in
                1) setup_start_env_macos;;
		2) setup_start_env_linux;;
                3) exit 0;;
                *) echo -e "${RED}Error...${STD}" && sleep 2
        esac
}

# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Main logic - infinite loop
# ------------------------------------
while true
do

        show_menus
        read_options
done
