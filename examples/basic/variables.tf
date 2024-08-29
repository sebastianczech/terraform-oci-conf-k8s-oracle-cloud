variable "region" {
  description = "Oracle Cloud region"
  type        = string
}

variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "id_rsa" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

variable "availability_domains" {
  description = "Availability domains in which instances are going to be created"
  type        = list(number)
  default     = [1, 1]
}

variable "egress_security_rules" {
  description = "Egress security rules"
  type        = list(map(string))
  default = [{
    destination      = "0.0.0.0/0"
    protocol         = "all"
    destination_type = "CIDR_BLOCK"
    description      = "Allow all outgoing traffic"
  }]
  validation {
    condition     = (length(var.egress_security_rules) > 0 && anytrue([for rule in var.egress_security_rules : rule["destination"] == "0.0.0.0/0"]))
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 destination."
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["protocol"])]))
    error_message = "Every item in the egress security rules has to contain procotol."
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["destination"])]))
    error_message = "Every item in the egress security rules has to contain destination."
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["destination_type"])]))
    error_message = "Every item in the egress security rules has to contain destination_type."
  }
  validation {
    condition     = (length(var.egress_security_rules) > 0 && alltrue([for rule in var.egress_security_rules : can(rule["description"])]))
    error_message = "Every item in the egress security rules has to contain description."
  }
}

variable "ingress_security_rules" {
  description = "Ingress security rules"
  type        = list(map(string))
  default = [{
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for SSH"
    port        = 22
    }, {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for HTTP"
    port        = 80
    }, {
    protocol    = 6
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for HTTPS"
    port        = 443
    }, {
    protocol    = 1
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow all for ICMP"
    icmp_type   = 3
    icmp_code   = 4
  }]
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && anytrue([for rule in var.ingress_security_rules : rule["source"] == "0.0.0.0/0"]))
    error_message = "At least 1 rule should be defined for 0.0.0.0/0 source."
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["protocol"])]))
    error_message = "Every item in the ingress security rules has to contain procotol."
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["source"])]))
    error_message = "Every item in the ingress security rules has to contain source."
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["source_type"])]))
    error_message = "Every item in the ingress security rules has to contain source_type."
  }
  validation {
    condition     = (length(var.ingress_security_rules) > 0 && alltrue([for rule in var.ingress_security_rules : can(rule["description"])]))
    error_message = "Every item in the ingress security rules has to contain description."
  }
}
