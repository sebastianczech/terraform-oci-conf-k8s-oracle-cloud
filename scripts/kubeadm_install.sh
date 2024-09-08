# # https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/

# # on all hosts
# sudo apt-get update
# sudo apt-get install -y apt-transport-https ca-certificates curl gpg
# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# sudo apt-get update
# sudo apt-get install -y kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl
# sudo systemctl enable --now kubelet

# sudo apt install -y vim
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update
# sudo apt-get install -y containerd.io

# # fix problem:
# # failed to create new CRI runtime service: validate service connection: validate CRI v1 runtime API for endpoint "unix:///var/run/containerd/containerd.sock": rpc error: code = Unimplemented desc = unknown service runtime.v1.RuntimeService[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
# # by editing file: sudo vi /etc/containerd/config.toml
# # and removing "cri": disabled_plugins = []

# sudo systemctl enable containerd
# sudo systemctl start containerd
# sudo systemctl restart containerd kubelet

# # fix problem:
# # /proc/sys/net/ipv4/ip_forward contents are not set to 1
# # sudo vi /etc/sysctl.conf
# # and uncomment: net.ipv4.ip_forward=1
# # sudo sysctl --system

# # on 1 node
# sudo kubeadm init --ignore-preflight-errors 'All'
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
# export KUBECONFIG=/etc/kubernetes/admin.conf

# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml

# # on 2 node
# sudo kubeadm join 172.16.0.237:6443 --ignore-preflight-errors 'All' --token *** \
#         --discovery-token-ca-cert-hash sha256:***
