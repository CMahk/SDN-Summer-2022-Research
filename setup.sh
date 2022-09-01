#!/bin/sh

# Get full list of packages
sudo apt update && sudo apt upgrade -y

# Install NPM and python2/3 dependencies
sudo apt install npm -y
sudo apt install python-pip python-dev python-setuptools -y
sudo apt install python3 -y
sudo apt install python3-pip python3-dev python3-setuptools -y
pip3 install --upgrade pip
pip3 install selenium

# Clone ONOS and use version 2.7.0
git clone https://gerrit.onosproject.org/onos
cd onos
git fetch
git checkout 2.7.0

# Install Bazelisk to automatically determine Bazel version to build ONOS with
sudo apt install g++ unzip zip -y
sudo wget https://github.com/bazelbuild/bazelisk/releases/download/v1.4.0/bazelisk-linux-amd64
sudo chmod +x bazelisk-linux-amd64
sudo mv bazelisk-linux-amd64 /usr/local/bin/bazel
sudo bazel version
sudo sed -i -e '22s/$/ --no-same-user/' ./onos/tools/package/onos-prep-karaf

# Add environment variables for Bazel and ONOS
export PATH="$HOME/bin:$PATH"
echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.bashrc
echo 'export ONOS_ROOT="`pwd`"' >> $HOME/.bashrc
echo 'source $ONOS_ROOT/tools/dev/bash_profile'

# Run Bazel to build ONOS
bazel build onos

# Install Mininet
sudo apt-get install mininet -y

# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin maven -y

# Install additional programs for ease of use
sudo apt-get install -y sshpass chromium-browser wireshark

# Install noVNC and setup for access
sudo git clone https://github.com/novnc/noVNC.git
mkdir /home/$USER/.vnc
echo "password" | vncpasswd -f > /home/$USER/.vnc/passwd
sudo chown -R $USER:$USER /home/$USER/.vnc
sudo chmod 0600 /home/$USER/.vnc/passwd

cd ./noVNC
sudo ./utils/novnc_proxy --vnc localhost:5901
