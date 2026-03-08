resource "zfs_filesystem" "vyos_router" {
  name = "${var.zfs_parent_dataset_name}/vyos-router"
}

resource "zfs_volume" "vyos_router_root" {
  name    = "${zfs_filesystem.vyos_router.name}/disk"
  volsize = var.zfs_zvol_size
  sparse  = false

  property {
    name  = "compression"
    value = "zstd"
  }

  property {
    name  = "volblocksize"
    value = "16K"
  }
}
