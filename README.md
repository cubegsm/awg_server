
# Docker update

sudo apt purge docker
sudo apt update
sudo apt install net-tools mc make cmake htop curl software-properties-common ca-certificates apt-transport-https -y

curl -fsSL https://get.docker.com -o get-docker.sh
sudo chmod +x get-docker.sh
sudo sh ./get-docker.sh

