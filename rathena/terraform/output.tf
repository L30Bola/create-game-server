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
  filename = "../ansible/inventory/inventory.ini"
  file_permission = "0644"
  depends_on = [
    aws_instance.ec2
  ]
  content = <<-EOF
    [ragnarok]
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

resource "local_file" "key-file" {
  filename = "../ansible/key.pem"
  file_permission = "0600"
  depends_on = [
    tls_private_key.generated_key
  ]
  content = tls_private_key.generated_key.private_key_pem
}
