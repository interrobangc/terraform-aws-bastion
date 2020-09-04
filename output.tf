output "public_ip" {
  value = module.bastion.public_ip
}

output "sg_ssh_allow_bastion" {
  value = [aws_security_group.ssh_allow_bastion.*.id]
}
