variable "id_rsa" {
  type = string
}

variable "compute_instances" {
  type = map(any)
}

variable "my_public_ip" {
  description = "my public IP address"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.my_public_ip))
    error_message = "Public IP address must be a valid IPv4 CIDR"
  }
}

variable "subnet_cidr" {
  type = string
}

variable "lb_id" {
  type = string
}