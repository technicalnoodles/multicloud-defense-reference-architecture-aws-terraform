#!/bin/bash
echo "export CISCO_CLIENT_ID=value" >> /etc/environment
echo "export CISCO_CLIENT_SECRET=value" >> /etc/environment
echo "export NODE_ENV=production" >> /etc/environment
echo "export MONGO_URI=mongodb://cloudsuite:cloudsuite@${db_endpoint}:27017/?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false" >> /etc/environment
echo "export MONGO_CLOUD_URI=mongodb://cloudsuite:cloudsuite@${db_endpoint}:27017/?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false" >> /etc/environment
echo "export COOKIE_KEY=['asdfasdfvaeas']" >> /etc/environment
echo "export PORT=80" >> /etc/environment
echo "export SSE_URI=/api/personalities/update" >> /etc/environment

export CISCO_CLIENT_ID="value"
export CISCO_CLIENT_SECRET="value"
export NODE_ENV="production"
export MONGO_URI="mongodb://cloudsuite:cloudsuite@${db_endpoint}:27017/?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
export MONGO_CLOUD_URI="mongodb://cloudsuite:cloudsuite@${db_endpoint}:27017/?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
export COOKIE_KEY="['asdfasdfvaeas']"
export PORT="80"
export SSE_URI="/api/personalities/update"

source ~/.bashrc
source .bashrc
cd /
yum update -y
yum install -y curl rpm unzip iptables ip6tables openssl dmidecode nc
yum install -y libksba
aws s3 cp ${secure_workload_installer} .
chmod +x tetration_installer_cisco-safe_enforcer_linux_tes.sh
bash tetration_installer_cisco-safe_enforcer_linux_tes.sh --new --skip-pre-check=all
echo "installing python"
yum install python3 -y
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py 
pip install langchain==0.0.171
pip3 install ecdsa==0.13.1
echo "installing node"
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
yum install nodejs -y
node -e "console.log('Running Node.js ' + process.version)"
npm install pm2@latest -g
echo "copying code"
aws s3 cp ${app_to_install_location_s3} .
echo $(pwd)
sudo tar -xvf safetower.tar.gz
cd safe-tower
echo $(pwd)
wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem
echo "installing root of web app"
npm i
cd client
echo "installing client of web app"
npm i
npm run build
cd ../docs
echo "installing docs of web app"
npm i
npm run build
cd ..
echo "running  web app"
pkill -f PM2
pm2 start index.js --cron-restart="*/5 * * * *"
