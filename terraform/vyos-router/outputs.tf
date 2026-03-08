output "domain_name" {
  description = "Managed libvirt domain name."
  value       = libvirt_domain.vyos_router.name
}

output "domain_id" {
  description = "Managed libvirt domain identifier."
  value       = libvirt_domain.vyos_router.id
}

output "zfs_zvol_name" {
  description = "ZFS volume backing the VyOS root disk."
  value       = zfs_volume.vyos_router_root.name
}

output "zfs_zvol_device_path" {
  description = "Host block device path for the VyOS zvol."
  value       = "/dev/zvol/${zfs_volume.vyos_router_root.name}"
}

output "installer_iso_effective_path" {
  description = "ISO path mounted in the VM (uploaded path if vyos_installer_iso_local_path is set)."
  value       = local.vyos_installer_iso_effective_path
}
