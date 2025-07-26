resource "oci_core_vcn" "cloud-nieradko-com-vcn" {
  cidr_block     = "10.0.0.0/16"
  dns_label      = "nieradkocloud"
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  display_name   = "${local.prefix}-vcn"
  freeform_tags  = local.tags
}

resource "oci_core_security_list" "cloud-nieradko-com-securitylist" {
  vcn_id         = oci_core_vcn.cloud-nieradko-com-vcn.id
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  display_name   = "${local.prefix}-securitylist"
  freeform_tags  = local.tags

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = oci_core_vcn.cloud-nieradko-com-vcn.cidr_block
    source_type = "CIDR_BLOCK"
    protocol    = "1" # ICMP
    description = "Allow ICMP from the VCN"
  }

  ingress_security_rules {
    stateless   = false
    source      = oci_core_vcn.cloud-nieradko-com-vcn.cidr_block
    source_type = "CIDR_BLOCK"
    protocol    = "1" # ICMP
    description = "Allow ICMP from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 80
      max = 80
    }
    description = "Allow HTTP from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 443
      max = 443
    }
    description = "Allow HTTPS from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 6443
      max = 6443
    }
    description = "Allow Kubernetes API ports from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 9345
      max = 9345
    }
    description = "Allow RKE2 supervisor API ports from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 10250
      max = 10250
    }
    description = "Allow kubelet metrics ports from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 30000
      max = 32767
    }
    description = "Allow NodePort port range from the Internet"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "17" # UDP
    udp_options {
      min = 30000
      max = 32767
    }
    description = "Allow NodePort port range from the Internet"
  }
}

resource "oci_core_internet_gateway" "cloud-nieradko-com-internetgateway" {
  vcn_id         = oci_core_vcn.cloud-nieradko-com-vcn.id
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  display_name   = "${local.prefix}-internetgateway"
  freeform_tags  = local.tags
}

resource "oci_core_route_table" "cloud-nieradko-com-routetable" {
  vcn_id         = oci_core_vcn.cloud-nieradko-com-vcn.id
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  display_name   = "${local.prefix}-routetable"
  freeform_tags  = local.tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.cloud-nieradko-com-internetgateway.id
  }
}

resource "oci_core_subnet" "cloud-nieradko-com-subnet" {
  vcn_id         = oci_core_vcn.cloud-nieradko-com-vcn.id
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  display_name   = "${local.prefix}-subnet"
  freeform_tags  = local.tags

  cidr_block        = "10.0.0.0/24"
  dns_label         = "subnet"
  security_list_ids = [oci_core_security_list.cloud-nieradko-com-securitylist.id]
  route_table_id    = oci_core_route_table.cloud-nieradko-com-routetable.id
}
