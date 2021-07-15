#!/bin/bash

# Radarr
apt update
apt install -y curl mediainfo sqlite3 sudo
wget --content-disposition 'http://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64'
tar -xvzf Radarr*.linux*.tar.gz
rm *.tar.gz
mkdir -p /opt/Radarr
mv Radarr /opt/
useradd radarr
groupadd media
usermod -aG sudo radarr
usermod -aG media radarr

sudo cat > /etc/systemd/system/radarr.service << EOF
[Unit]
Description=Radarr Daemon
After=syslog.target network.target

[Service]
User=radarr
Group=media
Type=simple
ExecStart=/opt/Radarr/Radarr -nobrowser -data=/opt/Radarr/.config/
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
systemctl enable --now radarr

# Jackett
wget https://github.com/Jackett/Jackett/releases/download/v0.18.379/Jackett.Binaries.LinuxAMDx64.tar.gz
tar -xvzf Jackett*
mkdir -p /opt/Jackett
rm -f *.tar.gz
mv Jackett* /opt/
cat > /etc/systemd/system/jackett.service << EOF
[Unit]
Description=Jackett Daemon
After=network.target

[Service]
SyslogIdentifier=jackett
Restart=always
RestartSec=5
Type=simple
User=root
Group=root
WorkingDirectory=/opt/Jackett
ExecStart=/bin/sh "/opt/Jackett/jackett_launcher.sh"
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now jackett

# Sonarr
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 2009837CBFFD68F45BC180471F4F90DE2A9B4BF8
echo "deb https://apt.sonarr.tv/debian buster main" | sudo tee /etc/apt/sources.list.d/sonarr.list
apt update
apt install -y sonarr