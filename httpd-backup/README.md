# Proxmox VM Backup with Ansible

This Ansible project automates the backup process for Proxmox VMs running Apache httpd.

## Features

- **VM Backup**: Full Proxmox VM backup using `vzdump`
- **HTTPD Config Backup**: Backup Apache configuration files separately
- **Graceful Service Management**: Optionally stop/start httpd during VM backup
- **Retention Policy**: Automatic cleanup of old backups
- **Multi-OS Support**: Works with RHEL/CentOS (httpd) and Debian/Ubuntu (apache2)

## Directory Structure

```
httpd-backup/
├── playbook.yml              # Main playbook for Proxmox VM backup
├── httpd-config-backup.yml   # Playbook for Apache config backup only
├── inventory.ini             # Ansible inventory file
├── group_vars/
│   └── all.yml              # Global variables
├── ansible.cfg              # Ansible configuration
└── README.md                # This file
```

## Prerequisites

1. **Ansible** installed on your control machine
   ```bash
   pip install ansible
   ```

2. **SSH Access**:
   - SSH access to Proxmox host (for vzdump)
   - SSH access to httpd VMs (for service management and config backup)

3. **Proxmox Requirements**:
   - Proxmox VE installed
   - `vzdump` command available
   - Sufficient storage space for backups

4. **VM Requirements**:
   - Apache httpd or apache2 installed
   - SSH access with sudo privileges

## Configuration

### 1. Update Inventory

Edit `inventory.ini` with your actual hosts:

```ini
[proxmox]
pve1 ansible_host=192.168.1.10 ansible_user=root

[httpd_vms]
web1 ansible_host=192.168.1.100 ansible_user=root
```

### 2. Configure Variables

Edit `group_vars/all.yml` or set environment variables:

```yaml
vm_id: "101"                    # Proxmox VM ID to backup
proxmox_host: "pve1"            # Proxmox hostname
httpd_vm_ip: "192.168.1.100"   # IP of the VM running httpd
backup_storage: "local"         # Proxmox storage name
backup_mode: "snapshot"         # Backup mode: stop, suspend, snapshot
```

### 3. Set Proxmox Password

**Option A**: Use ansible-vault (recommended)
```bash
ansible-vault encrypt_string 'your_password' --name proxmox_password
# Add the encrypted string to group_vars/all.yml
```

**Option B**: Use environment variable
```bash
export PROXMOX_PASSWORD=your_password
```

**Option C**: Use SSH keys (no password needed)

## Usage

### Full VM Backup (with httpd service management)

Backup the entire Proxmox VM, optionally stopping httpd first:

```bash
ansible-playbook playbook.yml
```

With custom variables:
```bash
ansible-playbook playbook.yml \
  -e "vm_id=101" \
  -e "proxmox_host=pve1" \
  -e "httpd_vm_ip=192.168.1.100" \
  -e "stop_httpd=true"
```

### HTTPD Configuration Backup Only

Backup only Apache configuration files (without VM backup):

```bash
ansible-playbook httpd-config-backup.yml
```

Backup configs for specific hosts:
```bash
ansible-playbook httpd-config-backup.yml --limit web1
```

### Check Inventory

Verify your inventory:
```bash
ansible-inventory --list
```

### Test Connectivity

Test SSH connectivity:
```bash
ansible all -m ping
```

## Backup Modes

- **snapshot**: Creates snapshot backup (VM stays running) - **Recommended**
- **suspend**: Suspends VM during backup
- **stop**: Stops VM completely during backup

## Compression Options

- **zstd**: Fast compression (recommended)
- **gzip**: Standard compression
- **lzo**: Fast but less compression

## Backup Locations

- **Proxmox VM backups**: `/var/lib/vz/dump/` on Proxmox host
- **HTTPD config backups**: `/var/backups/httpd/` on VM (configurable)

## Retention Policy

Old backups are automatically cleaned up based on `retention_days` (default: 30 days).

## Troubleshooting

### Permission Issues

Ensure SSH user has sudo privileges:
```bash
ansible httpd_vms -m shell -a "sudo -l" -K
```

### vzdump Not Found

Ensure you're running on the Proxmox host or have proper SSH access:
```bash
ansible proxmox -m shell -a "which vzdump"
```

### Service Name Detection

The playbook auto-detects `httpd` vs `apache2`. To override:
```bash
ansible-playbook playbook.yml -e "httpd_service_name=apache2"
```

### Backup Storage Full

Check available space:
```bash
ansible proxmox -m shell -a "df -h /var/lib/vz/dump"
```

## Security Notes

- Never commit passwords to version control
- Use ansible-vault for sensitive data
- Restrict SSH access with firewall rules
- Use SSH keys instead of passwords when possible

## Example Workflow

1. **Daily automated backup** (via cron):
   ```bash
   0 2 * * * cd /path/to/httpd-backup && ansible-playbook playbook.yml
   ```

2. **Weekly config backup**:
   ```bash
   0 3 * * 0 cd /path/to/httpd-backup && ansible-playbook httpd-config-backup.yml
   ```

3. **Manual backup before changes**:
   ```bash
   ansible-playbook playbook.yml -e "vm_id=101"
   ```

## License

This project is provided as-is for automation purposes.

