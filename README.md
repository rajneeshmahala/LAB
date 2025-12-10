# Terraform Proxmox Ubuntu VM

This Terraform configuration creates Ubuntu virtual machines on Proxmox infrastructure.

## Prerequisites

1. **Terraform** (v1.0+) - [Install](https://www.terraform.io/downloads)
2. **Proxmox Server** with API access
3. **Proxmox API Token** - Create a user and token for Terraform
4. **Ubuntu Cloud-Init Template** - Pre-configured in Proxmox

## Setup Instructions

### 1. Create Proxmox API Token

On your Proxmox server, create an API token:
```bash
# SSH into Proxmox
ssh root@proxmox-server

# Create a user (optional, use existing if available)
pveum user add terraform@pam

# Create a token for the user
pveum acl modify / -user terraform@pam -role Administrator
pveum token add terraform@pam terraform --privsep=0
```

Note the token ID and secret returned by `pveum token add`.

### 2. Prepare Configuration

1. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your Proxmox details:
```hcl
proxmox_api_url      = "https://your-proxmox-ip:8006/api2/json"
proxmox_api_token_id = "terraform@pam!terraform"
proxmox_api_token    = "your-token-here"
proxmox_node         = "pve"  # Your Proxmox node name
```

3. (Optional) Update VM specifications:
```hcl
vm_name      = "my-ubuntu-vm"
vm_cores     = 4
vm_memory    = 4096
vm_disk_size = 64
```

### 3. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan the deployment
terraform plan -out=tfplan

# Apply the configuration
terraform apply tfplan
```

## Outputs

After successful deployment, Terraform outputs:
- `vm_id` - Proxmox VM ID
- `vm_name` - VM hostname
- `vm_node` - Proxmox node location
- `vm_status` - Current VM status

## Network Configuration

### DHCP (Default)
VMs are configured for DHCP by default. Check your Proxmox/network for assigned IP.

### Static IP
To configure static IP, uncomment and modify in `main.tf`:
```hcl
ipconfig0 = "ip=192.168.1.100/24,gw=192.168.1.1"
```

## Cloud-Init Customization

For custom user data scripts, create a cloud-init snippet in Proxmox:
```bash
# On Proxmox server
mkdir -p /var/lib/vz/snippets
cat > /var/lib/vz/snippets/cloud-init-user-data.yml <<EOF
#cloud-config
packages:
  - htop
  - curl
runcmd:
  - apt-get update
  - apt-get upgrade -y
EOF
```

Update `main.tf` to reference your snippet.

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Troubleshooting

### API Connection Failed
- Verify Proxmox API URL and port (default 8006)
- Check API token is valid: `pveum token list`
- Ensure TLS certificate is valid or set `proxmox_tls_insecure = true`

### Template Not Found
- Verify template name exists in Proxmox: `qm template`
- Template must have cloud-init support

### IP Address Not Assigned
- Check network bridge (`vmbr0`) configuration in Proxmox
- Verify DHCP server is running on your network

## References

- [Terraform Proxmox Provider](https://github.com/Telmate/terraform-provider-proxmox)
- [Proxmox API Documentation](https://pve.proxmox.com/pve-docs/api-viewer/)
- [Cloud-Init Documentation](https://cloud-init.io/)
