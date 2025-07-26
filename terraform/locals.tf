locals {
    prefix = "cloud-nieradko-com"

    tags = merge(
        var.tags,
        {
            "project" = "cloud-nieradko-com"
        }
    )
}