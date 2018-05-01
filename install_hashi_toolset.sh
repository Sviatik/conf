#!/bin/bash

set -x

function check_su {
    if [[ "$(id -u)" != '0' ]]; then
        echo 'Please run with sudo'
        exit 1
    else
        check_dist
    fi
}

check_su

# Set Variable
VAULT_URL="https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip"
TERRAFORM_URL="https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip"
PACKER_URL="https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip"

BIN_PATH="/usr/bin"
TMP_PATH="/tmp"
# Pre requirements 
unzip -hh 2&> /dev/null

if [ $? -ne 0 ]; then
	apt install unzip
	exit 0
fi

cd ${TMP_PATH}

if [ ! -f ${BIN_PATH}/vault ]; then
    wget ${VAULT_URL}
    unzip -o `echo ${VAULT_URL} | cut -d '/' -f 6`
    sudo mv ${TMP_PATH}/vault ${BIN_PATH}
    vault -autocomplete-install
fi


if [ ! -f ${BIN_PATH}/packer ]; then
    wget ${PACKER_URL}
    unzip -o `echo ${PACKER_URL} | cut -d '/' -f 6`
    sudo mv ${TMP_PATH}/packer ${BIN_PATH}
fi


if [ ! -f ${BIN_PATH}/terraform ]; then
    wget ${TERRAFORM_URL}
    unzip -o `echo ${TERRAFORM_URL} | cut -d '/' -f 6`
    sudo mv ${TMP_PATH}/terraform ${BIN_PATH}
fi


