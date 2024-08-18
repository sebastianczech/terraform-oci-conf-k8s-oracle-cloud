variable "id_rsa" {
  description = "Path to the private key file"
  type        = string
}

variable "compute_instances" {
  description = "A map of compute instances to create"
  type        = map(any)
}

variable "my_public_ip" {
  description = "My public IP address"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.my_public_ip))
    error_message = "Public IP address must be a valid IPv4 CIDR."
  }
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "lb_id" {
  description = "ID of the load balancer"
  type        = string
}
