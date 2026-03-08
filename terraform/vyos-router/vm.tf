resource "libvirt_domain" "vyos_router" {
  name      = "vyos-router"
  type      = "kvm"
  memory    = 8 * 1024 * 1024
  vcpu      = 4
  autostart = true
  depends_on = [
    terraform_data.upload_vyos_installer_iso,
  ]

  cpu = {
    mode = "host-passthrough"
  }

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    boot_devices = local.vyos_installer_iso_effective_path != "" ? [
      { dev = "cdrom" },
      { dev = "hd" },
      ] : [
      { dev = "hd" },
    ]
  }

  devices = {
    disks = concat(
      [
        {
          source = {
            block = {
              dev = "/dev/zvol/${zfs_volume.vyos_router_root.name}"
            }
          }
          target = {
            dev = "vda"
            bus = "virtio"
          }
        },
      ],
      local.vyos_installer_iso_effective_path != "" ? [
        {
          source = {
            file = {
              file = local.vyos_installer_iso_effective_path
            }
          }
          target = {
            dev = "sda"
            bus = "sata"
          }
          device = "cdrom"
        },
      ] : []
    )
    interfaces = [
      {
        type = "bridge"
        source = {
          bridge = {
            bridge = "brMgmt"
          }
        }
      },
      {
        type = "bridge"
        source = {
          bridge = {
            bridge = "brVyos"
          }
        }
      },
    ]
    consoles = [
      {
        type        = "pty"
        target_type = "serial"
        target_port = 0
      },
    ]
  }
}
