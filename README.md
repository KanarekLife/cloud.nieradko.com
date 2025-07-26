# cloud.nieradko.com

My personal cloud services.

## Terraform

```sh
$ mkdir -p ~/.oci

# Generate API key
$ openssl genrsa -out ~/.oci/cloud-nieradko-com-key.pem 4096
$ chmod 600 ~/.oci/cloud-nieradko-com-key.pem
$ openssl rsa -pubout -in ~/.oci/cloud-nieradko-com-key.pem -out ~/.oci/cloud-nieradko-com-key.pem.pub
```
