#!/bin/bash

set -e  # Exit on errors

ANSIBLE_USER="ansadmin"

# Check if ansible user exists in /etc/passwd
if id "$ANSIBLE_USER" &>/dev/null; then
  echo "User '$ANSIBLE_USER' exists. Exiting. therefore the environment is already set"
  service ssh start
  sleep infinity
  exit 0
fi


echo "🔄 [1] (init) Updating package lists and installing SSH server..."
apt update
apt install -y openssh-server sudo adduser passwd vim

echo "🔧 [2] (init) Disabling SSH password authentication..."
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*UsePAM .*/UsePAM no/' /etc/ssh/sshd_config
service ssh restart

echo "👤 [3] (init) Creating user 'ansadmin' with sudo privileges..."
useradd -m -s /bin/bash ansadmin
echo "ansadmin:anspass" | chpasswd
usermod -aG sudo ansadmin

echo "🔑 [4] (init) Setting up SSH authorized_keys for 'ansadmin'..."
mkdir -p /home/ansadmin/.ssh
touch /home/ansadmin/.ssh/authorized_keys
chmod 700 /home/ansadmin/.ssh
chmod 600 /home/ansadmin/.ssh/authorized_keys
chown -R ansadmin:ansadmin /home/ansadmin/.ssh

echo "✅ [5] (init) Setup complete! You can now add your public key to /home/ansadmin/.ssh/authorized_keys"

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs5Ie+KAzf4coHZlUFDe/hCc8rSwYnygKiQV6gZNvYI ansadmin@LPL-5CG5203JL8" >> /home/ansadmin/.ssh/authorized_keys

echo "🔄 [6] (init) Start ssh and run"
service ssh start
sleep infinity

