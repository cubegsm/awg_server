


AmneziaWG VPS Server is a minimal Docker-based setup for deploying a self-hosted VPN server using Amnezia WireGuard.
The project is designed for fast and reproducible deployment of a VPN gateway on any VPS without manual system configuration.
Inside the container, amneziawg-tools and amneziawg-go are built and used, while the VPN server operates through the standard Linux TUN interface.
The main goal of the project is to provide a simple and transparent way to run your own VPN server with full infrastructure control, without relying on third-party VPN providers.
The container runs in an isolated environment and can be easily deployed, rebuilt, or migrated to another server.



# Docker update

sudo apt purge docker
sudo apt update
sudo apt install net-tools mc make cmake htop curl software-properties-common ca-certificates apt-transport-https -y

curl -fsSL https://get.docker.com -o get-docker.sh
sudo chmod +x get-docker.sh
sudo sh ./get-docker.sh

