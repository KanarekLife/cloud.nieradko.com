terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.11.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.7.0"
    }
  }
  backend "oci" {
    bucket           = "cloud-nieradko-com-bucket"
    namespace        = "fr7tp5oepog1"
    tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaag5cxlj46epjabavmoi3iohqh7gxddyj3apb4strfrv3mbj245c5q"
    user_ocid        = "ocid1.user.oc1..aaaaaaaah4a5ukkrc3772gevzhunfxgr25e3jw6kjs64tnnxsjdwr34jqptq"
    fingerprint      = "b3:03:4c:43:6e:fa:d4:69:17:12:6f:3c:f1:9e:ee:b9"
    private_key_path = "~/.oci/cloud-nieradko-com-key.pem"
    region           = "eu-frankfurt-1"
  }
}

provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaag5cxlj46epjabavmoi3iohqh7gxddyj3apb4strfrv3mbj245c5q"
  user_ocid        = "ocid1.user.oc1..aaaaaaaah4a5ukkrc3772gevzhunfxgr25e3jw6kjs64tnnxsjdwr34jqptq"
  fingerprint      = "b3:03:4c:43:6e:fa:d4:69:17:12:6f:3c:f1:9e:ee:b9"
  region           = "eu-frankfurt-1"
  private_key_path = "~/.oci/cloud-nieradko-com-key.pem"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
