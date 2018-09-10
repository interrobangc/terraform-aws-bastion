variable "env" {
  description = "Environment we are running in"
  default     = "default"
}

variable "vpc_id" {
  description = "VPC ID that bastion host will reside in"
}

variable "vpc_ids_count" {
  description = "count of vpc_ids"
  default     = 1
}

variable "vpc_ids" {
  type        = "list"
  description = "VPC IDs that hosts will exist in"
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

variable "key_name" {
  description = "name of EC2 key for instance"
  default     = false
}
