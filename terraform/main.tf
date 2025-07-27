resource "oci_budget_budget" "kanareklifecloud-budget" {
  display_name   = "oci-budget"
  amount         = 1
  compartment_id = var.root_compartment_id
  targets        = [var.root_compartment_id]
  reset_period   = "MONTHLY"
}

resource "oci_budget_alert_rule" "kanareklifecloud-budgetalertrule" {
  budget_id      = oci_budget_budget.kanareklifecloud-budget.id
  threshold      = 1
  threshold_type = "ABSOLUTE"
  type           = "FORECAST"

  display_name = "oci-budgetalert"
  message      = "Over 1 USD will be spent!"
  recipients   = "stanislaw@nieradko.com"
}

resource "oci_identity_compartment" "cloud-nieradko-com-compartment" {
  compartment_id = var.root_compartment_id
  description    = "Root compartment for cloud.nieradko.com project"
  name           = local.prefix
  freeform_tags  = local.tags
}

resource "oci_objectstorage_bucket" "cloud-nieradko-com-bucket" {
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  name           = "${local.prefix}-bucket"
  namespace      = var.oci_bucket_namespace

  access_type   = "NoPublicAccess"
  versioning    = "Enabled"
  freeform_tags = local.tags
}

resource "oci_core_instance" "cloud-nieradko-com-instance" {
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  display_name   = "${local.prefix}-node-${count.index}"
  freeform_tags  = local.tags
  count          = 2

  availability_domain = data.oci_identity_availability_domain.ad.name
  fault_domain        = data.oci_identity_fault_domains.fault_domains.fault_domains[count.index % length(data.oci_identity_fault_domains.fault_domains.fault_domains)].name
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu.images[0].id
    boot_volume_size_in_gbs = 100
    boot_volume_vpus_per_gb = 120
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.cloud-nieradko-com-subnet.id
    assign_public_ip          = true
    assign_private_dns_record = true
    display_name              = "${local.prefix}-node-${count.index}-vnic"
    hostname_label            = "${local.prefix}-node-${count.index}"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_key
  }

  lifecycle {
    ignore_changes = [
      source_details[0].source_id
    ]
  }
}

resource "oci_core_volume_backup_policy" "cloud-nieradko-com-instancebackuppolicy" {
  compartment_id = oci_identity_compartment.cloud-nieradko-com-compartment.id
  display_name   = "${local.prefix}-instance-backup-policy"
  freeform_tags  = local.tags

  # Weekly backup with 2 weeks retention
  schedules {
    backup_type       = "INCREMENTAL"
    period            = "ONE_WEEK"
    retention_seconds = 13.5 * 24 * 60 * 60 # Delete the backup before creating a new one to avoid billing issues
    hour_of_day       = 0
    day_of_week       = "SUNDAY"
  }
}

resource "oci_core_volume_backup_policy_assignment" "cloud-nieradko-com-instancebackuppolicyassignment" {
  count = length(oci_core_instance.cloud-nieradko-com-instance)

  asset_id  = oci_core_instance.cloud-nieradko-com-instance[count.index].boot_volume_id
  policy_id = oci_core_volume_backup_policy.cloud-nieradko-com-instancebackuppolicy.id
}
