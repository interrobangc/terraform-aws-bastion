variable "env" {
  description = "Environment we are running in"
  default     = "default"
}

variable "vpc_ids" {
  type        = "map"
  description = "VPC IDs"
}

variable "security_groups" {
  type        = "list"
  description = "Security groups for bastion"
}

variable "subnets" {
  type        = "list"
  description = "Subnet ids for bastion"
}

variable "count" {
  description = "Number of bastiones (defaults to one per subnet)"
  default     = false
}

variable "create_prod_sg" {
  description = "Should we create prod security group?"
  default     = true
}

variable "create_dev_sg" {
  description = "Should we create dev security group?"
  default     = true
}
