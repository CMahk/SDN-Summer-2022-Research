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

# Clone ONOS and use version 2.5.0
git clone https://gerrit.onosproject.org/onos
cd onos
git fetch
git checkout 2.5.0

# Install Bazel version 3.0.0 for ONOS 2.5.0
sudo apt install g++ unzip zip -y
wget https://github.com/bazelbuild/bazel/releases/download/3.0.0/bazel-3.0.0-installer-linux-x86_64.sh
chmod +x bazel-3.0.0-installer-linux-x86_64.sh
./bazel-3.0.0-installer-linux-x86_64.sh --user

# Add environment variables for Bazel and ONOS
export PATH="$HOME/bin:$PATH"
echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.bashrc
echo 'export ONOS_ROOT="`pwd`"' >> $HOME/.bashrc
echo 'source $ONOS_ROOT/tools/dev/bash_profile'

# Run Bazel to build ONOS
#bazel build onos

# Install Mininet
sudo apt-get install mininet -y

# Install Docker
sudo apt-get update
sudo apt-get update && apt-get install -y lsb-release && apt-get clean all
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io maven -y
