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
