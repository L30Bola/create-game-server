locals {
  key_name = "rathena"
  rathena_ports = [
    {
      port        = -1
      description = "ICMP (Ping)"
      protocol    = "icmp"
    },
    {
      port        = 22
      description = "SSH"
      protocol    = "tcp"
    },
    {
      port        = 6900
      description = "Login Server"
      protocol    = "tcp"
    },
    {
      port        = 6121
      description = "Char Server"
      protocol    = "tcp"
    },
    {
      port        = 5121
      description = "Map Server"
      protocol    = "tcp"
    },
    {
      port        = 8888
      description = "Web Server"
      protocol    = "tcp"
    }
  ]
  ami_owner = "099720109477"
  ami_name = "lunar-23.04"
  ami_architecture = "amd64"
}