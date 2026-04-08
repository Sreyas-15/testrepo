# Ansible Demo Portfolio Project

A minimal Ansible demonstration project showcasing core Ansible functionality with AWS infrastructure deployed via Terraform.

## Project Structure

```
ansible-demo-portfolio/
├── terraform/              # Infrastructure as Code
│   ├── main.tf             # Main Terraform configuration
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output values
│   └── versions.tf         # Provider versions
├── ansible/                # Ansible configuration
│   ├── inventory/
│   │   └── hosts.yml       # Inventory file
│   ├── playbooks/
│   │   ├── site.yml        # Main playbook
│   │   └── templates/      # Jinja2 templates
│   ├── group_vars/
│   │   └── all.yml         # Group variables
│   └── ansible.cfg         # Ansible configuration
├── README.md
└── .gitignore
```

## Architecture

- **1 Ansible Control Node**: Amazon Linux 2 instance with Ansible installed
- **2 Web Servers**: Amazon Linux 2 instances to be configured by Ansible
- **VPC**: Custom VPC with public subnet for simplified networking
- **Security**: Uses AWS SSM Session Manager for secure access (no SSH keys required)

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- AWS SSM Session Manager plugin (for connecting to instances)

## Deployment Instructions

### 1. Deploy Infrastructure

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### 2. Get Instance Information

After deployment, get the private IPs and instance IDs:

```bash
# Get outputs
terraform output

# Note the private IPs for updating Ansible inventory
```

### 3. Update Ansible Inventory

Update `ansible/inventory/hosts.yml` with the actual private IPs from Terraform output:

```yaml
all:
  children:
    webservers:
      hosts:
        web1:
          ansible_host: <ACTUAL_PRIVATE_IP_1>
        web2:
          ansible_host: <ACTUAL_PRIVATE_IP_2>
      vars:
        ansible_user: ec2-user
```

### 4. Connect to Ansible Control Node

Use SSM Session Manager to connect to the control node:

```bash
# Connect to control node
aws ssm start-session --target <CONTROL_NODE_INSTANCE_ID>

# Once connected, switch to ec2-user
sudo su - ec2-user
```

### 5. Set Up SSH Keys (for Ansible connectivity)

On the control node, generate SSH keys and copy them to the web servers:

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""

# Copy public key to web servers (you'll need to do this via SSM for each server)
# For each web server, connect via SSM and add the public key to authorized_keys
```

**Alternative approach**: Copy the Ansible files to the control node and use the ec2-user's existing access.

### 6. Copy Ansible Files

Copy the ansible directory to the control node:

```bash
# On your local machine, you can use SCP through SSM or copy files manually
# For simplicity, you can recreate the files on the control node
```

### 7. Run Ansible Playbook

On the control node:

```bash
# Navigate to ansible directory
cd ansible

# Test connectivity
ansible all -m ping

# Run the playbook
ansible-playbook playbooks/site.yml

# Run with specific tags
ansible-playbook playbooks/site.yml --tags "web,content"

# Run in check mode (dry run)
ansible-playbook playbooks/site.yml --check
```

## What This Demo Showcases

### Ansible Features Demonstrated

1. **Inventory Management**: YAML-based inventory with groups
2. **Variables**: Group variables and facts
3. **Modules**:
   - `yum` - Package management
   - `systemd` - Service management
   - `file` - File operations
   - `template` - Jinja2 templating
   - `uri` - HTTP requests for validation
   - `firewalld` - Firewall configuration
4. **Templates**: Jinja2 templates with variables and facts
5. **Handlers**: Service restart handlers
6. **Tags**: Task organization and selective execution
7. **Facts**: System information gathering
8. **Conditionals**: Basic conditional logic
9. **Error Handling**: `ignore_errors` for optional tasks

### Infrastructure Features

1. **AWS VPC**: Custom networking
2. **Security Groups**: Minimal required access
3. **IAM Roles**: SSM Session Manager access
4. **EC2 Instances**: Right-sized for demo
5. **User Data**: Basic instance bootstrapping

## Accessing the Web Application

After running the playbook, you can access the web servers:

1. Get the public IPs from AWS console or Terraform output
2. Visit `http://<PUBLIC_IP>` to see the main page
3. Visit `http://<PUBLIC_IP>/info.html` for system information

## Security Features

- **No SSH Keys Required**: Uses AWS SSM Session Manager
- **Minimal Security Groups**: Only necessary ports open
- **IAM Roles**: Least privilege access
- **Private Communication**: Instances communicate via private IPs

## Cleanup

To destroy the infrastructure:

```bash
cd terraform
terraform destroy
```

## Common Commands

```bash
# Check Ansible version
ansible --version

# List all hosts
ansible all --list-hosts

# Check connectivity
ansible all -m ping

# Gather facts
ansible all -m setup

# Run specific tasks
ansible-playbook playbooks/site.yml --tags "packages"

# Limit to specific hosts
ansible-playbook playbooks/site.yml --limit "web1"

# Verbose output
ansible-playbook playbooks/site.yml -v
```

## Troubleshooting

1. **SSH Connection Issues**: Ensure the control node can reach web servers via private IP
2. **Permission Denied**: Check that ec2-user has proper SSH key access
3. **Package Installation Fails**: Verify internet connectivity and package names
4. **Service Start Fails**: Check logs with `journalctl -u httpd`

## Learning Objectives

This project demonstrates:

- Basic Ansible playbook structure
- Infrastructure provisioning with Terraform
- Security best practices with SSM
- Common Ansible modules and patterns
- Template usage with Jinja2
- Variable management
- Task organization with tags
- Service management and validation

Perfect for showcasing foundational Ansible knowledge in a portfolio!
