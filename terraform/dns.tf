resource "cloudflare_dns_record" "cloud-nieradko-com-instance-record" {
  count = length(oci_core_instance.cloud-nieradko-com-instance)

  name    = "node-${count.index}.k8s.nieradko.com"
  zone_id = var.cloudflare_zone_id
  type    = "A"
  ttl     = 1
  content = oci_core_instance.cloud-nieradko-com-instance[count.index].public_ip
}

resource "cloudflare_dns_record" "cloud-nieradko-com-cluster-record" {
  count = length(oci_core_instance.cloud-nieradko-com-instance)

  name    = "k8s.nieradko.com"
  zone_id = var.cloudflare_zone_id
  type    = "A"
  ttl     = 1
  content = oci_core_instance.cloud-nieradko-com-instance[count.index].public_ip
}

resource "cloudflare_dns_record" "cloud-nieradko-com-root-record" {
  name    = "@"
  zone_id = var.cloudflare_zone_id
  type    = "CNAME"
  ttl     = 1
  content = "k8s.nieradko.com"
}

resource "cloudflare_dns_record" "cloud-nieradko-com-argocd-record" {
  name    = "argocd"
  zone_id = var.cloudflare_zone_id
  type    = "CNAME"
  ttl     = 1
  content = "k8s.nieradko.com"
}
