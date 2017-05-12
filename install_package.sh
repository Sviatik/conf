#!/bin/bash

yum_package="vim tree wget git unzip net-tools bash-completion telnet nmap docker-ce ansible yum-utils"
apt_package="vim tree wget git unzip net-tools bash-completion telnet nmap"






function test_install {
    if [[ -f /etc/redhat-release ]]; then
        # update system
        yum update
        # Add repo
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        #Update cache
        yum makecache fast
        yum -y install $yum_package
    elif [[ -f /etc/debian_version ]]; then
        apt update && apt upgrade
        apt install -y $apt_package  
    else
        echo 'unknow distro'
        exit 1
    fi
}

#test_install


function check_su {
    if [[ "$(id -u)" != '0' ]]; then
        echo 'Please run with sudo'
        exit 1
    else
        test_install
    fi
}

check_su