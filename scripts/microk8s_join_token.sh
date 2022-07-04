echo "Generate command to join node in K8s cluster"

microk8s add-node | head -2 | tail -1 > /tmp/join_${node_name}.command
sed -i "s/$/ \|\| true/" /tmp/join_${node_name}.command