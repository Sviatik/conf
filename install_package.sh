#!/bin/bash

yum_package="vim tree wget git unzip net-tools bash-completion telnet nmap docker ansible"
apt_package="vim tree wget git unzip net-tools bash-completion telnet nmap"

function test_install {
    if [[ -f /etc/redhat-release ]]; then
        yum -y install $yum_package
    elif [[ -f /etc/debian_version ]]; then
        apt install -y $apt_package  
    else
        echo 'unknow distro'
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