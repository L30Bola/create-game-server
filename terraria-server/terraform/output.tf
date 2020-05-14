output "ec2_public_ips" {
  value = aws_instance.ec2.*.public_ip
  depends_on = [
    aws_instance.ec2
  ]
}

output "ec2_private_ips" {
  value = aws_instance.ec2.*.private_ip
  depends_on = [
    aws_instance.ec2
  ]
}
resource "local_file" "ansible-inventory" {
  filename = "../ansible/inventory.ini"
  file_permission = "0644"
  depends_on = [
    aws_instance.ec2
  ]
  content = <<-EOF
    [terraria-server]
    ${join("\n",
      formatlist(
        "%s ansible_host=%s private_ip=%s",
        aws_instance.ec2.*.tags.Name,
        aws_instance.ec2.*.public_ip,
        aws_instance.ec2.*.private_ip
      )
    )}
  EOF
}
