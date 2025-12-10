output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_vm_qemu.ubuntu_vm.id
}

output "vm_name" {
  description = "VM Name"
  value       = proxmox_vm_qemu.ubuntu_vm.name
}

output "vm_node" {
  description = "Proxmox node where VM is running"
  value       = proxmox_vm_qemu.ubuntu_vm.target_node
}

output "vm_status" {
  description = "VM status"
  value       = proxmox_vm_qemu.ubuntu_vm.status
}
