resource "proxmox_vm_qemu" "ubuntu_vm" {
  name        = var.vm_name
  target_node = var.proxmox_node
  clone       = var.ubuntu_template

  # CPU Configuration
  cores   = var.vm_cores
  sockets = 1
  cpu     = "host"

  # Memory Configuration
  memory = var.vm_memory

  # Disk Configuration
  disk {
    type    = "scsi"
    storage = var.vm_storage
    size    = "${var.vm_disk_size}G"
  }

  # Network Configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Boot Configuration
  boot = "order=scsi0"

  # Cloud-Init Configuration
  citype = "nocloud"

  # Specify cloud-init user data for initial configuration
  # This can include SSH key setup, package updates, etc.
  cicustom = "user=local:snippets/cloud-init-user-data.yml"

  # Optional: Static IP configuration
  # Uncomment and modify for your network setup
  # ipconfig0 = "ip=${var.vm_ipv4_address},gw=${var.vm_ipv4_gateway}"

  # VM lifecycle
  lifecycle {
    ignore_changes = [
      citype,
      cicustom
    ]
  }

  # Wait for cloud-init to complete
  depends_on = []
}
