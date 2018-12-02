locals {
  default_key_name = "${var.env}_terraform_ec2_key"
}

resource "aws_security_group" "bastion_ssh_source" {
  name        = "bastion_ssh_source"
  description = "Used as ssh source for ssh_allow_bastion policy"
  vpc_id      = "${var.vpc_id}"

  tags = {
    Terraform = "true"
    Name      = "bastion_ssh_source"
    env       = "${var.env}"
  }
}

resource "aws_security_group" "ssh_allow_bastion" {
  count       = "${var.vpc_ids_count}"
  name        = "ssh_allow_bastion"
  description = "Allow public ssh ingress"
  vpc_id      = "${var.vpc_ids[count.index]}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion_ssh_source.id}"]
  }

  depends_on = ["aws_security_group.bastion_ssh_source"]

  tags = {
    Terraform = "true"
    Name      = "ssh_allow_bastion"
    env       = "${var.env}"
  }
}

module "bastion" {
  source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance?ref=v1.13.0"

  name           = "bastion"
  instance_count = "${var.count}"

  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name == false ? local.default_key_name : var.key_name}"
  monitoring    = true
  subnets       = ["${var.subnets}"]

  vpc_security_group_ids = [
    "${aws_security_group.bastion_ssh_source.id}",
    "${var.security_groups}",
  ]

  associate_public_ip_address = true

  tags = {
    Terraform = "true"
    env       = "${var.env}"
  }
}
