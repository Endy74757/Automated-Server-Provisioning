# Terraform quick start (VirtualBox VMs)

Prereqs:
- Terraform >= 1.5
- Oracle VM VirtualBox installed and running
- VirtualBox provider (terra-farm/virtualbox) will download on init

Steps:
1. Ensure a Host-Only network exists
   - On Windows, open VirtualBox → File → Host Network Manager
   - Create one if missing. Note its name (e.g., `VirtualBox Host-Only Ethernet Adapter`)
   - Set `vm_host_interface` in `Terraform/variables.tf` or via `-var`
2. Initialize providers
   ```bash
   terraform -chdir=Terraform init
   ```
3. Review plan
   ```bash
   terraform -chdir=Terraform plan
   ```
4. Apply
   ```bash
   terraform -chdir=Terraform apply -auto-approve
   ```

Result:
- Creates 2 web VMs (`web-01`, `web-02`) and 1 control VM (`control-01`)
- Each VM uses host-only networking with DHCP
- Outputs IPv4 addresses for web and control VMs separately

Notes:
- Default image is Ubuntu bionic64 `.box` URL. You can set a local path instead.
- On Windows, run your shell as Administrator if VirtualBox networking changes are needed.
- **Host-only network setup**: Ensure DHCP is enabled in VirtualBox Host Network Manager for the host-only adapter.
- **User data**: Each VM includes cloud-init user data from `user_data.txt`


