resource "aws_security_group" "bastion_ssh_source" {
  name        = "bastion_ssh_source"
  description = "Used as ssh source for ssh_allow_bastion policy"
  vpc_id      = "${var.vpc_ids["mgmt"]}"

  tags = {
    Terraform = "true"
    Name      = "bastion_ssh_source"
    env       = "${var.env}"
  }
}

resource "aws_security_group" "ssh_allow_bastion_mgmt" {
  name        = "ssh_allow_bastion"
  description = "Allow public ssh ingress"
  vpc_id      = "${var.vpc_ids["mgmt"]}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion_ssh_source.id}"]
  }

  tags = {
    Terraform = "true"
    Name      = "ssh_allow_bastion"
    env       = "${var.env}"
  }
}

resource "aws_security_group" "ssh_allow_bastion_dev" {
  count = "${var.create_dev_sg}"

  name        = "ssh_allow_bastion"
  description = "Allow public ssh ingress"
  vpc_id      = "${var.vpc_ids["dev"]}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion_ssh_source.id}"]
  }

  tags = {
    Terraform = "true"
    Name      = "ssh_allow_bastion"
    env       = "dev"
  }
}

resource "aws_security_group" "ssh_allow_bastion_prod" {
  count = "${var.create_prod_sg}"

  name        = "ssh_allow_bastion"
  description = "Allow public ssh ingress"
  vpc_id      = "${var.vpc_ids["prod"]}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion_ssh_source.id}"]
  }

  tags = {
    Terraform = "true"
    Name      = "ssh_allow_bastion"
    env       = "prod"
  }
}

module "bastion" {
  source = "github.com/interrobangc/terraform-aws-ec2-instance"

  name           = "bastion"
  instance_count = "${var.count}"

  ami           = "ami-3ecc8f46"
  instance_type = "t2.nano"
  key_name      = "terraform_ec2_key"
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
