data "oci_network_load_balancer_network_load_balancer" "k8s_network_load_balancer" {
  network_load_balancer_id = var.lb_id
}