output "public_ip" {
  value = "${module.bastion.public_ip}"
}

output "sg_ssh_allow_bastion_mgmt" {
  value = "${element(concat(aws_security_group.ssh_allow_bastion_mgmt.*.id, list("")), 0)}"
}

output "sg_ssh_allow_bastion_dev" {
  value = "${element(concat(aws_security_group.ssh_allow_bastion_dev.*.id, list("")), 0)}"
}

output "sg_ssh_allow_bastion_prod" {
  value = "${element(concat(aws_security_group.ssh_allow_bastion_prod.*.id, list("")), 0)}"
}
