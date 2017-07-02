#!/bin/bash

YUM_PACKAGE="vim tree wget git unzip net-tools bash-completion telnet nmap docker-ce ansible yum-utils"
APT_PACKAGE="vim tree wget git unzip net-tools bash-completion telnet nmap"






function check_dist {
    if [[ -f /etc/redhat-release ]]; then
        rhel

    elif [[ -f /etc/debian_version ]]; then
        debian

    else
        echo 'unknow dist'
        exit 1
    fi
}

#check_dist


function check_su {
    if [[ "$(id -u)" != '0' ]]; then
        echo 'Please run with sudo'
        exit 1
    else
        check_dist
    fi
}

function debian {
    #echo "function debian"

    apt update && apt upgrade
    apt install -y $APT_PACKAGE  
    echo $USER
    #check desktop environment
    desktop=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
    echo $desktop

    #conf terminal
    mkdir -p ~/.config/xfce4/terminal
    cat term > ~/.config/xfce4/terminal/terminalrc


}

function rhl {
    # update system
    yum update
    # Add repo
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    #Update cache
    yum makecache fast
    yum -y install $YUM_PACKAGE


}

check_su
