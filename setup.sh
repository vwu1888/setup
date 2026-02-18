#!/bin/bash
set -e

# Colors for pretty output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 1. Detect Machine (Simple Prompt)
echo "Which machine is this?"
echo "1) Framework 16"
read -p "Select (1/2): " choice

if [ "$choice" == "1" ]; then
    HOSTNAME="framework16"
else
    echo "Invalid choice."
    exit 1
fi

# 2. Install Ansible if missing
if ! command -v ansible &> /dev/null; then
    echo "Installing Ansible..."
    sudo dnf install -y ansible
fi

# 3. Check for Vault Password
if [ ! -f .vault_pass ]; then
    echo -e "${GREEN}Vault password file not found.${NC}"
    echo "Please enter your Ansible Vault password (to decrypt secrets):"
    read -s vault_pass
    echo "$vault_pass" > .vault_pass
    echo "Password saved to .vault_pass (It is gitignored)."
fi

# 4. Run the Playbook
echo "Running Ansible for $HOSTNAME..."
ansible-playbook playbook.yml -K -l $HOSTNAME
