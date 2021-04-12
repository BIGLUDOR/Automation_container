#!/bin/sh

#The user need to copy this script into the canisterA
echo "********** Evidencias para Canister A **********"
echo "Escriba el Numero de Orden"
read orden
echo "Escriba la letra del canister\t A \t B"
read canister

#Make the directories
ssh -o StrictHostKeyChecking=no root@192.168.45.11 "mkdir /home/fab3/prod/evidences-3k/$orden"
ssh -o StrictHostKeyChecking=no root@192.168.45.11 "ls -l /home/fab3/prod/evidences-3k/ | grep $orden"

if [ $? == 0 ]; then
	echo "Carpeta creada"
else
	echo "Carpeta no creada, revise conexion con GEMS"
fi
#Evidence to Canister A
echo -e "Particiones de disco SDA:\n" |tee -a canister${canister}_OUT_${orden}.txt
parted /dev/sda print |tee -a canister${canister}_OUT_${orden}.txt

echo -e "\n Particiones de disco SDB:\n" |tee -a canister${canister}_OUT_${orden}.txt
parted /dev/sdb print |tee -a canister${canister}_OUT_${orden}.txt

echo -e "\n Sincronizacion de RAIDs:\n" |tee -a canister${canister}_OUT_${orden}.txt 
cat /proc/mdstat |tee -a canister${canister}_OUT_${orden}.txt 

echo -e "\n Listado de discos:\n" |tee -a canister${canister}_OUT_${orden}.txt
lsblk |tee -a canister${canister}_OUT_${orden}.txt

echo -e "\n Usuario para SSR:\n" |tee -a canister${canister}_OUT_${orden}.txt
grep "essserv1" /etc/passwd |tee -a canister${canister}_OUT_${orden}.txt

echo -e "\n VPD listado:\n" |tee -a canister${canister}_OUT_${orden}.txt 
cat /vpd/vpd1.txt |tee -a canister${canister}_OUT_${orden}.txt

echo -e "\n Puerto de red SSR:\n" |tee -a canister${canister}_OUT_${orden}.txt
if [ -e  ifcfg-ethernet-enp1s0 ]; then
	cat /etc/sysconfig/network-scripts/ifcfg-ethernet-enp1s0 |tee -a canister${canister}_OUT_${orden}.txt
else 
	cat /etc/sysconfig/network-scripts/ifcfg-enp1s0 |tee -a canister${canister}_OUT_${orden}.txt
fi
echo "Evidencia para calidad creada"

#Clean up to high speed
rm -fv /etc/sysconfig/network-scripts/*bond* ; nmcli c reload
echo "Eliminando información del BOND"

#clean up to MGMT
sed -i "2,3d" /etc/sysconfig/network-scripts/ifcfg-enp29s0f0
echo "Eliminando las lineas del archivo ifcfg-enp29s0f0"

#send to evidence file
echo -e "\n Puerto de red MGMT:\n" |tee -a canister${canister}_OUT_${orden}.txt
cat /etc/sysconfig/network-scripts/ifcfg-enp29s0f0 |tee -a canister${canister}_OUT_${orden}.txt

#clean /etc/hosts
echo -e "127.0.0.1 \tlocalhost localhost.localdomain localhost4 localhost4.localdomain4\n::1 \t\tlocalhost localhost.localdomain localhost6 localhost6.localdomain6" > /etc/hosts; cat /etc/hosts

#install check
echo -e "\n Installcheck:\n"|tee -a canister${canister}_OUT_${orden}.txt
essinstallcheck -N $(hostname -s) |tee -a canister${canister}_OUT_${orden}.txt

#eliminate the hosts and input general hostname
(rm -fv /var/mmfs/etc/osestool*; rm -rfv /var/log/xcat/*; rm -rfv /etc/yum.repos.d/*repo; yum clean all; hostnamectl set-hostname localhost; cat /etc/hostname ; rm -rfv /root/.ssh/*; ssh-keygen -t rsa)

#Insert canister key
cat /root/.ssh/id_rsa.pub >> authorized_keys

#Save evidence
chage -d 0 root
echo -e "\n CA LAW evidencia:\n" |tee -a canister${canister}_OUT_${orden}.txt; 
chage -l root |tee -a canister${canister}_OUT_${orden}.txt

scp -o StrictHostKeyChecking=no canister${canister}_OUT_${orden}.txt root@192.168.45.11:/home/fab3/prod/evidences-3k/$orden