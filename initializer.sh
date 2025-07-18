#!/bin/bash

set -e  # Exit on errors

echo "🔄 [1] Updating package lists and installing SSH server..."
apt update
apt install -y openssh-server sudo adduser passwd vim

echo "🔧 [2] Disabling SSH password authentication..."
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*UsePAM .*/UsePAM no/' /etc/ssh/sshd_config
service ssh restart

echo "👤 [3] Creating user 'ansadmin' with sudo privileges..."
useradd -m -s /bin/bash ansadmin
echo "ansadmin:anspass" | chpasswd
usermod -aG sudo ansadmin

echo "🔑 [4] Setting up SSH authorized_keys for 'ansadmin'..."
mkdir -p /home/ansadmin/.ssh
touch /home/ansadmin/.ssh/authorized_keys
chmod 700 /home/ansadmin/.ssh
chmod 600 /home/ansadmin/.ssh/authorized_keys
chown -R ansadmin:ansadmin /home/ansadmin/.ssh

echo "✅ Setup complete! You can now add your public key to /home/ansadmin/.ssh/authorized_keys"

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBs5Ie+KAzf4coHZlUFDe/hCc8rSwYnygKiQV6gZNvYI ansadmin@LPL-5CG5203JL8" >> /home/ansadmin/.ssh/authorized_keys

