#!/bin/bash

#####################################################################################################################################################################
##############################   https://docs.k3s.io/installation/configuration
#####################################################################################################################################################################

# # on 1 server:
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - --flannel-backend=vxlan --token 12345
# export MASTER_IP=$(hostname -I | awk '{print $1}')
# echo $MASTER_IP
# # on 2 server:
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://${MASTER_IP}:6443 --token 12345" sh -s -
# # on all servers:
# sudo systemctl status k3s
# journalctl -u k3s -f

#####################################################################################################################################################################
##############################   https://docs.k3s.io/datastore/ha-embedded
#####################################################################################################################################################################

# # on 1 server:
# curl -sfL https://get.k3s.io | K3S_TOKEN=SECRET sh -s - server --cluster-init
# export MASTER_IP=$(hostname -I | awk '{print $1}')
# # on 2 server:
# curl -sfL https://get.k3s.io | K3S_TOKEN=SECRET sh -s - server --server https://${MASTER_IP}:6443

#####################################################################################################################################################################
##############################   https://docs.tigera.io/calico/latest/getting-started/kubernetes/k3s/multi-node-install
#####################################################################################################################################################################

# # on 1 server:
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none --disable-network-policy --cluster-cidr=192.168.0.0/16" sh -
# export MASTER_IP=$(hostname -I | awk '{print $1}')
# export NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# # on 2 server:
# curl -sfL https://get.k3s.io | K3S_URL=https://serverip:6443 K3S_TOKEN=mytoken sh -

# # setup Calico
# sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
# sudo kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml

#####################################################################################################################################################################
##############################   GEMINI
#####################################################################################################################################################################

# # Install K3s on the first node (master)
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-init" sh -

# # Get the node token from the master node
# export NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

# # Get the master node IP address
# export MASTER_IP=$(hostname -I | awk '{print $1}')

# # Install K3s on the second node (worker)
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--server https://${MASTER_IP}:6443 --token ${NODE_TOKEN}" sh -

# # Check the cluster status on the master node
# sudo kubectl get nodes

# # Example output:
# # NAME          STATUS   ROLES     AGE   VERSION
# # master-node   Ready    master   5m    v1.23.6+k3s1
# # worker-node   Ready    <none>   2m    v1.23.6+k3s1

# Explanation:

# Install K3s on the master node:

# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-init" sh - downloads and runs the K3s installation script with the --cluster-init flag, which initializes a new cluster.
# Get the node token and master IP:

# NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token) retrieves the node token from the master node, which is required for worker nodes to join the cluster.
# MASTER_IP=$(hostname -I | awk '{print $1}') gets the IP address of the master node.
# Install K3s on the worker node:

# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--server https://${MASTER_IP}:6443 --token ${NODE_TOKEN}" sh - installs K3s on the worker node and joins it to the cluster using the master node IP, port (6443), and the obtained node token.
# Check the cluster status:

# sudo kubectl get nodes lists all nodes in the cluster and their status.
# Before running the script:

# Ensure that you have SSH access to both nodes.
# Replace master-node and worker-node with the actual hostnames or IP addresses of your nodes.
# After running the script:

# You should see both nodes in the Ready state, indicating a successful cluster setup.
# You can now start deploying applications to your K3s cluster.
