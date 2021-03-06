#!/bin/bash

#YUM_PACKAGE="vim tree wget git unzip net-tools bash-completion telnet nmap docker-ce ansible yum-utils"

USER=sviat
APT_PACKAGE="vim virtualenv tree wget git unzip net-tools bash-completion telnet nmap tlp tlp-rdw google-chrome-stable openconnect \
    sublime-text remmina remmina-plugin-rdp keepassx docker-engine ansible ssh sshfs virtualbox-5.1 htop jq dos2unix whois"
#skype


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
    echo "INFO: Add repo"
    # Google repo
    wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    # Subl repo
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    # Docker repo
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
    # Ansible repo
    apt-add-repository -y ppa:ansible/ansible
    # VirtualBox
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" | sudo tee /etc/apt/sources.list.d/vbox.list
    # fix issue with ctrl-shift switch layout and copy/paste overlap
    sudo add-apt-repository ppa:nrbrtx/xorg-hotkeys


    echo "function debian"
    echo "INFO: install package"
    apt update && apt upgrade -y
    apt install -y $APT_PACKAGE  

}



check_su

#conf terminal
mkdir -p /home/$USER/.config/xfce4/terminal
wget https://github.com/sviatik/conf/raw/master/terminalrc -P /home/$USER/.config/xfce4/terminal

cd /tmp
wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
tar -xvf linux-amd64-1.1.0.tar.gz
cd linux-amd64-1.1.0
sudo mv ccat /usr/bin
cd ..
rm -rf linux-amd64-1.1.0.tar.gz linux-amd64-1.1.0 

docker pull microsoft/azure-cli

#Repo for upgreade baterry
#add-apt-repository ppa:linrunner/tlp

sudo usermod -aG vboxusers $USER
sudo usermod -aG docker $USER

# icons
cd /opt/
sudo git clone https://github.com/daniruiz/Flat-Remix
cd Flat-Remix/
sudo mv Flat\ Remix/ /usr/share/icons/

# thems | after that you should go to "Menu >> Settings >> Appearance >> Style “Choose the desired theme from the list” >> Finally close"
cd /usr/share/themes
sudo wget -O /usr/share/themes/OSX-Arc-White.tar.gz https://github.com/LinxGem33/OSX-Arc-White/archive/v1.3.7.tar.gz
sudo tar zxvf /usr/share/themes/OSX-Arc-White.tar.gz &> /dev/null
rm -rf /usr/share/themes/OSX-Arc-White.tar.gz

ln -s /tmp/ /home/$USER/tmp

rm -rf /home/$USER/.bashrc
wget https://github.com/sviatik/conf/raw/master/.bashrc -P /home/$USER/ 

echo "INFO: For install Package control in sublime-text3 pls press Ctr+~"
echo ""
echo "import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)"





