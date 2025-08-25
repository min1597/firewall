#!/bin/bash
#
# setup_ubuntu.sh: Ubuntu Server for XDP Firewall Project

set -e # Exit immediately if a command exits with a non-zero status.

echo "--- [1/5] Updating package lists ---"
sudo apt-get update

echo "--- [2/5] Installing system dependencies ---"
# Note: python3-pip is included to make sure python3-venv is available.
sudo apt-get install -y clang llvm libbpf-dev linux-headers-$(uname -r) \
                        python3 python3-pip git docker.io docker-compose

echo "--- [3/5] Installing Python libraries via apt ---"
# This is the recommended way on modern Debian/Ubuntu systems (PEP 668)
sudo apt-get install -y python3-libbpf python3-psycopg2 python3-geoip2

echo "--- [4/5] Setting up Docker ---"
sudo systemctl start docker
sudo systemctl enable docker
# Add current user to the docker group to run docker without sudo
# You may need to re-login for this to take effect.
if [ $(getent group docker) ]; then
    sudo usermod -aG docker $USER
    echo "Current user added to the docker group. Please re-login to use docker without sudo."
else
    echo "Docker group not found. Skipping user addition."
fi

echo "--- [5/5] Compiling eBPF code ---"
make

echo "
--- SETUP COMPLETE ---

Next steps:
1. (If not done) Upload your project to this server (e.g., via 'git clone').
2. (If not done) Download GeoIP databases into the 'userspace/' directory.
3. Start the database: docker-compose up -d
4. Run the firewall with root privileges:

   sudo python3 userspace/main.py --iface <your_network_interface>

Replace <your_network_interface> with your actual network device (e.g., eth0).
" 
