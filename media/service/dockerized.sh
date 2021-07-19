#!/bin/bash

NFS=$(ping -c 3 pz | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n 1)
dcVersion=$(curl "https://api.github.com/repos/docker/compose/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
serviceURL1=raw.githubusercontent.com/ppdlv/trifle/master/media/
serviceURL2=raw.githubusercontent.com/ppdlv/trifle/master/media/service
serviceLoc=/etc/systemd/system/

apt update
apt install -y curl nfs-common

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
# Docker-compose
curl -sL "https://github.com/docker/compose/releases/download/$dcVersion/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Add and mount NFS
echo $"$NFS:/iwolf/shared/Torrents /var/nfs/torrents nfs rw,bg,intr,hard,timeo=600 0 0
$NFS:/ironw/shared/Sonarr /var/nfs/sonarr/tv nfs rw,bg,intr,hard,timeo=600 0 0
$NFS:/ironw/shared/Radarr /var/nfs/radarr/mv nfs rw,bg,intr,hard,timeo=600 0 0" >> /etc/fstab
mount -a && df -h

mkdir -p /etc/compose/ && curl -sSL "https://$serviceURL1/docker-compose.yaml" -o /etc/compose/docker-compose.yml && chmod 744 /etc/compose/docker-compose.yml
curl -sSL "https://$serviceURL2/docker-compose-reload.service" -o $serviceLoc/docker-compose-reload.service && chmod 777 $serviceLoc/docker-compose-reload.service
curl -sSL "https://$serviceURL2/docker-compose-reload.timer" -o $serviceLoc/docker-compose-reload.timer && chmod 777 $serviceLoc/docker-compose-reload.timer
curl -sSL "https://$serviceURL2/docker-compose.service" -o $serviceLoc/docker-compose.service && chmod 777 $serviceLoc/docker-compose.service
systemctl daemon-reload
systemctl enable docker-compose.service