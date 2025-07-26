variable "root_compartment_id" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaag5cxlj46epjabavmoi3iohqh7gxddyj3apb4strfrv3mbj245c5q"
}

variable "oci_bucket_namespace" {
  type    = string
  default = "fr7tp5oepog1"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "availability_domain" {
  type    = number
  default = 2
}

variable "ssh_authorized_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECNiO2jUclVP5/tJI+o0CAqAoJgoCH1AMsivi8cr9up stanislaw@nieradko.com"
}
