apt update
apt install zsh -y
apt upgrade -y
apt autoremove -y
mkdir1=$(mkdir -p /usr/share/zsh-autosuggestions)
mkdir2=$(mkdir -p /usr/share/zsh-syntax-highlighting)
curl1=$(curl -o /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh -O https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/zsh-autosuggestions.zsh)
curl2=$(curl -o /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zip -O https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/zsh-syntax-highlighting.zip)
unzip=$(unzip /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zip -d /usr/share/zsh-syntax-highlighting)
removezip=$(rm -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zip)

## Reserved for downloading config files to local host
curl -O https://raw.githubusercontent.com/ppdlv/trifle/main/zsh/.zshrc -o /root
$mkdir1
$mkdir2 
$unzip
chsh -s /bin/zsh && exit
