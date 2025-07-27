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
