variable "chopin_host_ip" {
  type        = string
  description = "IP address of the chopin libvirt host."
}

variable "chopin_ssh_user" {
  type        = string
  description = "SSH user for chopin."
  default     = "root"
}

variable "chopin_ssh_private_key_path" {
  type        = string
  description = "Optional path to SSH private key for chopin."
  default     = ""
}

variable "zfs_parent_dataset_name" {
  type        = string
  description = "Existing parent ZFS dataset under which per-VM datasets are created."
  default     = "zroot/vm-disks"
}

variable "zfs_zvol_size" {
  type        = string
  description = "ZFS zvol size for the VyOS root disk."
  default     = "20G"
}

variable "vyos_installer_iso_path" {
  type        = string
  description = "Optional absolute path on the libvirt host to a VyOS installer ISO. Leave empty to disable installer media."
  default     = ""
}

variable "vyos_installer_iso_local_path" {
  type        = string
  description = "Optional local path to a VyOS installer ISO to upload to chopin before attaching."
  default     = ""
}

variable "vyos_installer_iso_remote_dir" {
  type        = string
  description = "Directory on chopin where the VyOS installer ISO is uploaded."
  default     = "/var/lib/libvirt/images"
}

variable "vyos_install_enable" {
  type        = bool
  description = "Run post-boot console automation to log in and execute install command."
  default     = false
}

variable "vyos_install_initial_wait_seconds" {
  type        = number
  description = "Seconds to wait after VM start before sending console input."
  default     = 45
}

variable "vyos_install_console_timeout_seconds" {
  type        = number
  description = "Overall timeout for the virsh console automation session."
  default     = 300
}

variable "vyos_install_login_username" {
  type        = string
  description = "Username sent to the VM console before running install command."
  default     = "vyose"
}

variable "vyos_install_login_password" {
  type        = string
  description = "Password sent to the VM console before running install command."
  default     = "vyos"
  sensitive   = true
}

variable "vyos_install_command" {
  type        = string
  description = "Command sent after login on the VM console."
  default     = "install image"
}
