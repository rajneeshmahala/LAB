# Proxmox Configuration
variable "proxmox_api_url" {
  description = "Proxmox API endpoint URL"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID (user@pam!token_name)"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Disable TLS verification"
  type        = bool
  default     = false
}

# VM Configuration
variable "proxmox_node" {
  description = "Proxmox node name where VM will be created"
  type        = string
}

variable "vm_name" {
  description = "Name of the Ubuntu VM"
  type        = string
  default     = "ubuntu-vm"
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "RAM memory in MB"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 32
}

variable "vm_storage" {
  description = "Storage location (e.g., local-lvm)"
  type        = string
  default     = "local-lvm"
}

variable "ubuntu_template" {
  description = "Ubuntu cloud-init template name"
  type        = string
  default     = "ubuntu-20.04-cloudinit"
}

variable "vm_ipv4_address" {
  description = "IPv4 address for the VM (CIDR notation)"
  type        = string
  default     = ""
}

variable "vm_ipv4_gateway" {
  description = "IPv4 gateway address"
  type        = string
  default     = ""
}

variable "vm_dns_servers" {
  description = "DNS server addresses"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
  default     = ""
}
