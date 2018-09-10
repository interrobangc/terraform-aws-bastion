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

  tags = {
    Terraform = "true"
    Name      = "ssh_allow_bastion"
    env       = "${var.env}"
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
