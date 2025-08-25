#!/bin/bash
#
# setup_ubuntu.sh: Ubuntu Server for XDP Firewall Project

set -e # Exit immediately if a command exits with a non-zero status.

echo "--- [1/6] Updating package lists ---"
sudo apt-get update

echo "--- [2/6] Installing system dependencies (including python3-venv) ---"
sudo apt-get install -y clang llvm libbpf-dev linux-headers-$(uname -r) \
                        python3 python3-pip python3-venv git docker.io docker-compose

echo "--- [3/6] Creating Python virtual environment ---"
python3 -m venv .venv
echo "Virtual environment created at ./.venv/"

echo "--- [4/6] Installing Python libraries into virtual environment ---"
# Use pip from the virtual environment, no sudo needed
.venv/bin/pip install -r requirements.txt

echo "--- [5/6] Setting up Docker ---"
sudo systemctl start docker
sudo systemctl enable docker
if [ $(getent group docker) ]; then
    sudo usermod -aG docker $USER
    echo "Current user added to the docker group. You may need to re-login to use docker without sudo."
fi

echo "--- [6/6] Compiling eBPF code ---"
make

echo "
--- SETUP COMPLETE ---

Next steps:
1. (If not done) Upload your project to this server (e.g., via 'git clone').
2. (If not done) Download GeoIP databases into the 'userspace/' directory.
3. Start the database: docker-compose up -d
4. Run the firewall using python from the virtual environment:

   sudo .venv/bin/python3 userspace/main.py --iface <your_network_interface>

Note the new run command using '.venv/bin/python3'.
Replace <your_network_interface> with your actual network device (e.g., eth0).
" 
