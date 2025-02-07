#!/bin/bash

# Update package list and upgrade system
sudo apt update && sudo apt upgrade -y

# Remove any existing NVIDIA installations
sudo apt purge nvidia* -y
sudo apt autoremove -y

# Add NVIDIA repository and update
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update

# Install required packages
sudo apt install -y \
    linux-headers-$(uname -r) \
    build-essential \
    dkms

# Install NVIDIA driver (latest version for A100)
sudo apt install -y nvidia-driver-535-server

# Disable nouveau driver
echo "blacklist nouveau
options nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf

# Update initramfs
sudo update-initramfs -u

# Load NVIDIA driver
sudo modprobe nvidia

# Verify installation
nvidia-smi
