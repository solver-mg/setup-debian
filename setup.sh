#Script para setup semiautomatico de um server Debian
#Por Bruno e Flavio Barbalho, Dezembro 2024 Brasilia, Brasil

#!/bin/bash
WAIT_TIME=2

echo "removendo ufw"
sleep $WAIT_TIME
sudo ufw disable
sudo apt -y remove --auto-remove ufw
sudo apt -y purge ufw
sudo apt -y purge --auto-remove ufw
sudo apt -y remove ufw 

echo "install iptables"
sleep $WAIT_TIME
sudo apt -y install iptables
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt -y install iptables-persistent

echo "Instalando Docker"
sleep $WAIT_TIME
sudo apt -y update && sudo apt -y upgrade 

[ -f /var/run/reboot-required ] && sudo reboot -f

sudo apt -y install lsb-release gnupg2 apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/debian.gpg
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt -y update
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
sudo systemctl start docker && sudo systemctl enable docker
systemctl status docker
echo "FIM"
