echo "********* update apt"
sudo apt update
sudo apt upgrade
echo "********* install curl"
sudo apt install -y curl
echo "********* add nodejs 18 source"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
echo "********* install nodejs 18.x"
sudo apt install -y nodejs
echo "********* nodejs version"
node -v