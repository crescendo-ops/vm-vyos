locals {
  vyos_installer_iso_uploaded_path  = var.vyos_installer_iso_local_path != "" ? "${trimsuffix(var.vyos_installer_iso_remote_dir, "/")}/${basename(var.vyos_installer_iso_local_path)}" : ""
  vyos_installer_iso_effective_path = var.vyos_installer_iso_local_path != "" ? local.vyos_installer_iso_uploaded_path : var.vyos_installer_iso_path
}

resource "terraform_data" "upload_vyos_installer_iso" {
  count = var.vyos_installer_iso_local_path != "" ? 1 : 0

  triggers_replace = [
    var.chopin_host_ip,
    var.chopin_ssh_user,
    var.chopin_ssh_private_key_path,
    var.vyos_installer_iso_local_path,
    var.vyos_installer_iso_remote_dir,
    filebase64sha256(var.vyos_installer_iso_local_path),
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-lc"]
    command     = <<-EOT
      set -euo pipefail

      KEY_OPT=""
      if [ -n "${var.chopin_ssh_private_key_path}" ]; then
        KEY_OPT="-i ${pathexpand(var.chopin_ssh_private_key_path)}"
      fi

      ssh $KEY_OPT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        ${var.chopin_ssh_user}@${var.chopin_host_ip} \
        "mkdir -p '${var.vyos_installer_iso_remote_dir}'"

      scp $KEY_OPT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        '${var.vyos_installer_iso_local_path}' \
        ${var.chopin_ssh_user}@${var.chopin_host_ip}:'${local.vyos_installer_iso_uploaded_path}'
    EOT
  }
}

resource "terraform_data" "run_vyos_install_over_console" {
  count = var.vyos_install_enable ? 1 : 0

  depends_on = [
    libvirt_domain.vyos_router,
    terraform_data.upload_vyos_installer_iso,
  ]

  triggers_replace = [
    libvirt_domain.vyos_router.id,
    var.chopin_host_ip,
    var.chopin_ssh_user,
    var.chopin_ssh_private_key_path,
    tostring(var.vyos_install_initial_wait_seconds),
    tostring(var.vyos_install_console_timeout_seconds),
    var.vyos_install_login_username,
    var.vyos_install_command,
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-lc"]
    command     = <<-EOT
      set -euo pipefail

      KEY_OPT=""
      if [ -n "${var.chopin_ssh_private_key_path}" ]; then
        KEY_OPT="-i ${pathexpand(var.chopin_ssh_private_key_path)}"
      fi

      ssh $KEY_OPT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        ${var.chopin_ssh_user}@${var.chopin_host_ip} \
        "timeout ${var.vyos_install_console_timeout_seconds}s bash -lc '{
          sleep ${var.vyos_install_initial_wait_seconds};
          printf \"\\n\";
          sleep 2;
          printf \"%s\\n\" \"${var.vyos_install_login_username}\";
          sleep 2;
          printf \"%s\\n\" \"${var.vyos_install_login_password}\";
          sleep 8;
          printf \"%s\\n\" \"${var.vyos_install_command}\";
          sleep 2;
          printf \"\\035\";
        } | virsh console --force ${libvirt_domain.vyos_router.name}'"
    EOT
  }
}
