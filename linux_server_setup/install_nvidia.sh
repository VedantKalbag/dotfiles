# #!/bin/bash

# # Update package list and upgrade system
# sudo apt update && sudo apt upgrade -y

# # Remove any existing NVIDIA installations
# sudo apt purge nvidia* -y
# sudo apt autoremove -y

# # Add NVIDIA repository and update
# sudo add-apt-repository ppa:graphics-drivers/ppa -y
# sudo apt update

# # Install required packages
# sudo apt install -y \
#     linux-headers-$(uname -r) \
#     build-essential \
#     dkms

# # Install NVIDIA driver (latest version for A100)
# sudo apt install -y nvidia-driver-535-server

# # Disable nouveau driver
# echo "blacklist nouveau
# options nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf

# # Update initramfs
# sudo update-initramfs -u

# # Load NVIDIA driver
# sudo modprobe nvidia

# # Verify installation
# nvidia-smi

#!/bin/bash
# eg. sudo bash install_nvidia.sh 12.5
set -e  # Exit on error
set -o pipefail  # Catch pipeline errors

# Default CUDA version
CUDA_VERSION=${1:-"12.6"}

# Detect OS
OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VERSION=$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

echo "Detected OS: $OS_ID $OS_VERSION"
echo "Installing NVIDIA drivers and CUDA $CUDA_VERSION..."

# Update package list & install dependencies
sudo apt update && sudo apt install -y linux-headers-$(uname -r) build-essential dkms wget software-properties-common

# Remove old NVIDIA/CUDA installations
echo "Removing existing NVIDIA and CUDA installations..."
sudo apt-get remove --purge -y '^nvidia-.*' '^libnvidia-.*' '^cuda-.*'
sudo apt autoremove -y && sudo apt clean

# Disable Nouveau driver
echo "Disabling Nouveau..."
echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u

# Install NVIDIA Drivers
if [[ "$OS_ID" == "ubuntu" ]]; then
    echo "Adding Ubuntu Graphics Drivers PPA..."
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo apt update
    sudo apt install -y nvidia-driver-535-server
elif [[ "$OS_ID" == "debian" ]]; then
    echo "Installing NVIDIA drivers from Debian repository..."
    sudo apt install -y nvidia-driver firmware-misc-nonfree
else
    echo "Unsupported OS: $OS_ID. Exiting..."
    exit 1
fi

# Install CUDA
echo "Installing CUDA $CUDA_VERSION..."
CUDA_DEB="cuda-repo-${OS_ID}${OS_VERSION}-${CUDA_VERSION}-local_${CUDA_VERSION}.*_amd64.deb"
CUDA_URL="https://developer.download.nvidia.com/compute/cuda/$CUDA_VERSION/local_installers/$CUDA_DEB"

wget "$CUDA_URL" -O "$CUDA_DEB"
sudo dpkg -i "$CUDA_DEB"
sudo cp /var/cuda-repo-${OS_ID}${OS_VERSION}-${CUDA_VERSION}-local/cuda-*-keyring.gpg /usr/share/keyrings/
rm -f "$CUDA_DEB"

# Enable contrib repo for Debian
[[ "$OS_ID" == "debian" ]] && sudo add-apt-repository contrib

# Install CUDA Toolkit and Drivers
sudo apt update && sudo apt install -y cuda-toolkit-${CUDA_VERSION//./-} cuda-drivers

# Verify Installation
echo "Verifying installation..."
nvidia-smi
nvcc --version

echo "Installation complete! A reboot is recommended if the kernel was updated."
