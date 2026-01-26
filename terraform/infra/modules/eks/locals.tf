locals {
  name = "${var.project}-${var.env}"

  common_tags = merge (
    {
        Project     = var.project
        Enviroument = var.env
        ManagedBy   = "terraform"
    },
    var.tags
  )
}
