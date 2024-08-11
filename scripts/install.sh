# https://microk8s.io/docs/install-alternatives

echo "Install required packages"

sudo apt update && sudo apt install docker.io -y && sudo snap install microk8s --classic --channel=1.23/stable && sudo snap install kubectl --classic

# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"

# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl