# rAthena Server

## Dependencies

To run this setup for rAthena Server you will need the following tools:
+ Terraform 
+ Poetry

## Terraform

To run the `terraform` step, you need to `cd` into the `terraform` directory:
```bash
$ cd terraform
```

Run a init:
```bash
$ terraform init
```

Then run apply:
```bash
$ terraform apply
```

This will create: 
+ a Security Group
+ a SSH Private Key (and will create it's file on `ansible/key.pem` for Ansible to use it)
+ an AWS Key Pair (the Public Key from the above Private Key)
+ an EC2 Instance
+ the Ansible inventory file on `ansible/inventory/inventory.ini`

### Temp
"http://nemo.herc.ws/get4.py"