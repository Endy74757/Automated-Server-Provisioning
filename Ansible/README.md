Ansible for DevOps on Terraform-provisioned VMs

Requirements:
- Ansible
- Terraform applied with output `vm_ips`

Workflow:
- Generate inventory: `cd Ansible/scripts; ./generate-inventory.ps1`
- Test: `ansible -i inventory/hosts.ini all -m ping`
- Apply: `ansible-playbook -i inventory/hosts.ini playbooks/site.yml`

