#!/bin/bash
yum -y update
yum repolist
yum install -y curl rpm unzip iptables ip6tables openssl dmidecode
#yum install python3 -y
#curl -O https://bootstrap.pypa.io/get-pip.py
#python3 get-pip.py 
#pip install langchain==0.0.171
#yum install -y libksba
yum install -y curl rpm unzip iptables ip6tables openssl dmidecode
aws s3 cp ${secure_workload_installer} .
chmod +x tetration_installer_cisco-safe_enforcer_linux_tes.sh
bash tetration_installer_cisco-safe_enforcer_linux_tes.sh --new --skip-pre-check=all
yum -y install yum-plugin-copr
yum -y copr enable @caddy/caddy epel-9-$(arch)
yum -y install caddy
yum install -y https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-116.0.5845.179-1.x86_64.rpm

caddy reverse-proxy --from :80 --to ${backend_lb}:80 & 