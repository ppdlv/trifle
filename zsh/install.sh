#!/bin/bash

function initialCheck() {
	isRoot
	checkOS
}

function isRoot() {
	if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
	fi
}

function checkOS() {
	# Check OS version
	if [[ -e /etc/debian_version ]]; then
		source /etc/os-release
		OS="${ID}" # debian or ubuntu
		if [[ ${ID} == "debian" || ${ID} == "raspbian" ]]; then
			if [[ ${VERSION_ID} -lt 10 ]]; then
				echo "Your version of Debian (${VERSION_ID}) is not supported. Please use Debian 10 Buster or later"
				exit 1
			fi
			OS=debian # overwrite if raspbian
		fi
	elif [[ -e /etc/fedora-release ]]; then
		source /etc/os-release
		OS="${ID}"
	elif [[ -e /etc/centos-release ]]; then
		source /etc/os-release
		OS=centos
	elif [[ -e /etc/oracle-release ]]; then
		source /etc/os-release
		OS=oracle
	elif [[ -e /etc/arch-release ]]; then
		OS=arch
	else
		echo "Looks like you aren't running this installer on a Debian, Ubuntu, Fedora, CentOS, Oracle or Arch Linux system"
		exit 1
	fi
}

function manageMenu() {
	echo "Detected that ZSH is already installed. Will now try to re-install to fix unwanted issues."
	installZSH
}

function installZSH() {
    apt update
    apt install zsh unzip wget curl -y
    apt upgrade -y
    apt autoremove -y
    mkdir -p /usr/share/zsh-autosuggestions
    mkdir -p /usr/share/zsh-syntax-highlighting
    curl -O https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/.zshrc -o $(pwd)
    curl -o /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh -O https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/zsh-autosuggestions.zsh
    wget -P /usr/share/zsh-syntax-highlighting https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/zsh-syntax-highlighting.zip
    unzip -o /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zip -d /usr/share/zsh-syntax-highlighting
    rm -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zip
    chsh -s /bin/zsh
}

# Check for root and OS...
initialCheck

# Check if WireGuard is already installed and load params
if [[ -e /etc/zsh ]]; then
	manageMenu
else
    echo "Doing first install workflow"
	installZSH
fi