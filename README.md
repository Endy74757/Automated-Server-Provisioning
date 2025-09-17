## Automated Server Provisioning (Terraform + Ansible)

A local infrastructure automation project that provisions Virtual Machines on Oracle VM VirtualBox using Terraform and configures them with Ansible. Designed as a hands-on portfolio/professional showcase: reproducible builds, clear structure, and pragmatic defaults for Windows hosts.

### What this project does
- **Provision VMs (VirtualBox)** via Terraform, supporting multiple VMs in one run
- **Networking**: NAT + Host‑Only (DHCP) for easy host↔guest access
- **Outputs**: Exposes per‑VM IPs for downstream tools
- **Configuration management** with Ansible roles (webserver, docker, common)
- **Inventory generation** helper script for Ansible

### Repository structure
- `Terraform/` — Terraform configuration for VirtualBox VMs
- `Ansible/` — Ansible playbooks, roles, inventory, and helper scripts
- `README.md` — You are here (project overview and quickstart)

## Prerequisites
- Windows 10/11 with administrator rights (for VirtualBox networking)
- [Oracle VM VirtualBox](https://www.virtualbox.org/)
- [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- [Ansible](https://docs.ansible.com/) (on Windows, use WSL or a control VM/container), or use a Linux/macOS control machine

Optional but recommended:
- PowerShell 7+
- `jq` for JSON processing (or use the PowerShell alternatives shown below)

## Quickstart

### 1) Terraform: create VMs on VirtualBox
From the repository root:
```powershell
terraform -chdir=Terraform init
terraform -chdir=Terraform plan
terraform -chdir=Terraform apply -auto-approve
```

Key variables (set in `Terraform/variables.tf` or via `-var`):
- `vm_names` — list of VM names (multi-VM). Example: `["webserver-01", "docker-01", "k8s"]`
- `vm_image` — VirtualBox `.box` image URL or local path (not an ISO)
- `vm_cpus`, `vm_memory` — resources per VM
- `vm_host_interface` — the exact name of the VirtualBox Host‑Only adapter
- `boot_wait_seconds` — wait after creation to allow boot

Outputs:
```powershell
terraform -chdir=Terraform output vm_ips
```
This returns a map of VM name → IPv4 address (host‑only adapter).

### VirtualBox networking notes (Windows)
- Ensure a Host‑Only adapter exists and **DHCP is enabled** (VirtualBox → File → Host Network Manager)
- Add VBoxManage to PATH for the current session:
```powershell
$env:Path += ';C:\Program Files\Oracle\VirtualBox'
VBoxManage --version
```
- If provider cannot get guest IPs, use images with **Guest Additions**. After first boot, you may need to run inside the VM:
```bash
sudo dhclient enp0s8
```
to acquire a DHCP address on the host‑only interface.

### 2) Ansible: configure the VMs
Update/generate inventory from Terraform outputs:
```powershell
pwsh Ansible\scripts\generate-inventory.ps1
```
Then run the site playbook:
```bash
ansible-playbook -i Ansible/inventory/hosts.ini Ansible/playbooks/site.yml
```

## Common tasks
- Create multiple VMs: set `vm_names = ["web-01","web-02","db-01"]`
- Inspect resources:
```powershell
terraform -chdir=Terraform state list
terraform -chdir=Terraform state show virtualbox_vm.vm["web-01"]
```
- Show outputs without apply (planned values):
```powershell
terraform -chdir=Terraform plan -out tfplan
(terraform -chdir=Terraform show -json tfplan | ConvertFrom-Json).planned_values.outputs | ConvertTo-Json -Depth 9
```

## Troubleshooting
- VBoxManage not found: add `C:\Program Files\Oracle\VirtualBox` to PATH
- VM not ready / IP is empty:
  - Use a VirtualBox `.box` with Guest Additions (ISO is not supported by the provider)
  - Ensure Host‑Only DHCP is enabled
  - Use NAT on adapter 0 and Host‑Only on adapter 1 if you customize networking
  - Inside guest, run `sudo dhclient enp0s8`
- Increase readiness timeouts by using images that boot faster and adjusting `boot_wait_seconds`

## Roadmap / Ideas
- Output SSH connection info and generate Ansible inventory automatically on `apply`
- Provisioners or cloud‑init style first‑boot customization
- Optional providers or backends for remote state

## License
MIT — use freely for learning and showcasing your automation skills.
