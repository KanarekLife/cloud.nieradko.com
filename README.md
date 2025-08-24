# cloud.nieradko.com

My personal cloud services.

## Terraform

```sh
$ mkdir -p ~/.oci

# Generate API key
$ openssl genrsa -out ~/.oci/cloud-nieradko-com-key.pem 4096
$ chmod 600 ~/.oci/cloud-nieradko-com-key.pem
$ openssl rsa -pubout -in ~/.oci/cloud-nieradko-com-key.pem -out ~/.oci/cloud-nieradko-com-key.pem.pub

# Create tfvars file
$ cp terraform/examples/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform/terraform.tfvars with your values
$ terraform init
```

## Ansible

```sh
$ cd ansible/

# Make sure to comment out inside inventory.ini:
#
# [nodes:vars]
# ansible_ssh_user=kanareklife
#
$ ansible-playbook create_user.yml -i inventory.ini
# Restore commented out lines in inventory.ini

$ ansible-playbook update.yml -i inventory.ini -K
$ ansible-playbook configure-iptables.yml -i inventory.ini -K
$ ansible-playbook configure-journalctl.yml -i inventory.ini -K
$ ansible-playbook disable-multipathd.yml -i inventory.ini -K
$ ansible-playbook increase-inotify-limit.yml -i inventory.ini -K
$ ansible-playbook reboot.yml -i inventory.ini -K
$ ansible-playbook setup_rke2.yml -i inventory.ini -K
```
