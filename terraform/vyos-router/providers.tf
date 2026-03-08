terraform {
  required_version = ">= 1.5.0"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.9.3"
    }
    zfs = {
      source  = "MathiasPius/zfs"
      version = ">= 0.6.1"
    }
  }
}

provider "libvirt" {
  uri = var.chopin_ssh_private_key_path != "" ? "qemu+ssh://${var.chopin_ssh_user}@${var.chopin_host_ip}/system?keyfile=${pathexpand(var.chopin_ssh_private_key_path)}&no_verify=1" : "qemu+ssh://${var.chopin_ssh_user}@${var.chopin_host_ip}/system?no_verify=1"
}

provider "zfs" {
  host     = var.chopin_host_ip
  user     = var.chopin_ssh_user
  key_path = var.chopin_ssh_private_key_path != "" ? pathexpand(var.chopin_ssh_private_key_path) : null
}
