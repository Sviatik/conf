#!/bin/bash

YUM_PACKAGE="vim tree wget git unzip net-tools bash-completion telnet nmap docker-ce ansible yum-utils"
APT_PACKAGE="vim tree wget git unzip net-tools bash-completion telnet nmap tlp tlp-rdw google-chrome-stable"


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
    echo -c "INFO: Add repo"
    if [[ -f /etc/apt/sources.list.d/google.list ]]
        cp ./google.list /etc/apt/sources.list.d/
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

    add-apt-repository ppa:linrunner/tlp
    
    #echo "function debian"
    echo -c "INFO: install package"
#    apt update && apt upgrade
#    apt install -y $APT_PACKAGE  
        
#    mkdir -p ~/.config/xfce4/terminal
    #cat term > ~/.config/xfce4/terminal/terminalrc


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
