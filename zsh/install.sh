#!/bin/bash

apt update
apt install zsh unzip -y
apt upgrade -y
apt autoremove -y
mkdir1=$(mkdir -p /usr/share/zsh-autosuggestions)
mkdir2=$(mkdir -p /usr/share/zsh-syntax-highlighting)
curl0=$(curl -O https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/.zshrc -o $(pwd))
curl1=$(curl -o /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh -O https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/zsh-autosuggestions.zsh)
wget=$(wget -P /usr/share/zsh-syntax-highlighting https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/zsh-syntax-highlighting.zip)
removezip=$(rm -f )

$mkdir1
$mkdir2
$curl0
$curl1
$wget
unzip -o /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zip -d /usr/share/zsh-syntax-highlighting
rm -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zip
chsh -s /bin/zsh
