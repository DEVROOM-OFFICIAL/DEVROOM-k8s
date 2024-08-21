#!/bin/bash

: '
스크립트 권한 설정
sudo chmod 755 install_k3s_server.sh
sudo chmod 755 install_k3s_agent.sh
'

LINE="===================="

# NFS 설치 & 마운트 여부 (단일노드만 사용할 경우 설치 안함)
read -p "Install NFS? (y/n): " install_nfs

if [[ "$install_nfs" == "y" || "$install_nfs" == "Y" ]]; then
    echo "${LINE} Install nfs... ${LINE}"
    read -p "Enter the nfs address: " mynfs
    sudo apt install -y nfs-common >> install.log 2>&1
    sudo mkdir -p /nfs_devroom >> install.log
    sudo mount ${mynfs} /nfs_devroom >> install.log
    sudo chmod -R 777 /nfs_devroom
    ls -al /nfs_devroom
else
    echo "Using single node storage ..."
    sudo mkdir -p /nfs_devroom >> install.log
    sudo chmod -R 777 /nfs_devroom
    ls -al /nfs_devroom
fi

echo "${LINE} Install k3s... ${LINE}"
read -p "Enter the K3S server address: " myserver
read -p "Enter the K3S node token: " mynodetoken
curl -sfL https://get.k3s.io | K3S_URL=https://${myserver}:6443 K3S_TOKEN=${mynodetoken} sh -s - > k3s_install.log