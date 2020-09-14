locals {
  default_key_name = "${var.env}_terraform_ec2_key"
}

resource "aws_security_group" "bastion_ssh_source" {
  count       = var.bastion_count > 0 ? 1 : 0
  name        = "bastion_ssh_source"
  description = "Used as ssh source for ssh_allow_bastion policy"
  vpc_id      = var.vpc_id

  tags = {
    Terraform = "true"
    Name      = "bastion_ssh_source"
    env       = var.env
  }
}

resource "aws_security_group" "ssh_allow_bastion" {
  count       = var.bastion_count > 0 ? var.vpc_ids_count : 0
  name        = "ssh_allow_bastion"
  description = "Allow public ssh ingress"
  vpc_id      = var.vpc_ids[count.index]

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_count > 0 ? aws_security_group.bastion_ssh_source.0.id : ""]
  }

  depends_on = [aws_security_group.bastion_ssh_source]

  tags = {
    Terraform = "true"
    Name      = "ssh_allow_bastion"
    env       = var.env
  }
}

module "bastion" {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance?ref=v2.15.0"

  name           = "bastion"
  instance_count = var.bastion_count

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name == false ? local.default_key_name : var.key_name
  monitoring    = true
  subnet_id     = var.bastion_count > 0 ? var.subnets.0 : false

  vpc_security_group_ids = concat(
    [var.bastion_count > 0 ? aws_security_group.bastion_ssh_source.0.id : ""],
    var.security_groups
  )

  associate_public_ip_address = true

  tags = {
    Terraform = "true"
    env       = var.env
  }
}
