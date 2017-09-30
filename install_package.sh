#!/bin/bash

#YUM_PACKAGE="vim tree wget git unzip net-tools bash-completion telnet nmap docker-ce ansible yum-utils"
APT_PACKAGE="vim tree wget git unzip net-tools bash-completion telnet nmap tlp tlp-rdw google-chrome-stable openconnect \
    sublime-text remmina remmina-plugin-rdp keepassx docker-engine"



function check_su {
    if [[ "$(id -u)" != '0' ]]; then
        echo 'Please run with sudo'
        exit 1
    else
        check_dist
    fi
}


function check_dist {
    if [[ -f /etc/redhat-release ]]; then
        echo "rhel"

    elif [[ -f /etc/debian_version ]]; then
        install_package

    else
        echo 'unknow dist'
        exit 1
    fi
}

#check_dist



function install_package {
    echo -c "INFO: Add repo"
    # Google repo
    wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    # Subl repo
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    # Docker repo
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'



    echo "function debian"
    echo -c "INFO: install package"
    apt update && apt upgrade -y
    apt install -y $APT_PACKAGE  
    mkdir -p ~/.config/xfce4/terminal
    cp terminalrc ~/.config/xfce4/terminal/terminalrc

}





check_su

docker run -it microsoft/azure-cli

#Repo for upgreade baterry
#add-apt-repository ppa:linrunner/tlp


# icons
cd /opt/
sudo git clone https://github.com/daniruiz/Flat-Remix
cd Flat-Remix/
sudo mv Flat\ Remix/ /usr/share/icons/

# thems | agter thet you sjould go to "Menu >> Settings >> Appearance >> Style “Choose the desired theme from the list” >> Finally close"
sudo wget -O /usr/share/themes/OSX-Arc-White.tar.gz https://github.com/LinxGem33/OSX-Arc-White/archive/v1.3.7.tar.gz
sudo tar zxvf OSX-Arc-White.tar.gz



ln -s /tmp/ /home/$USER/tmp
