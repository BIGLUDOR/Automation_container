#!/bin/sh
#Create by Luis Armando López
#This script can search the igth versio, but depends of script version_check_v1.sh
#-------------------colors--------------------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
#---------------------Variables---------------------------
name_conteiner=$(podman ps -a | awk 'FNR == 2 {print $1}')
id_images=$(podman images | awk 'NR == 2 {print $3}')
ls_podman_container=$(podman ps -a | wc -l)
ls_podman_images=$(podman images | wc -l)
hostname=$(hostname)
hostnumber=$(hostname | awk '{split($0,a,"-"); print(a[2]) }')
tar_version_dae="ess3000_6.1.0.0_0315-22_dae_ppc64le.tgz"
tar_version_dme="ess3000_6.1.0.0_0315-22_dme_ppc64le.tgz"
#function to create the container
function create_container (){
    #We receive the parameter about the data type
    datatype=$1
    if [ "$datatype" = "DataAccess" ]; then
        export INSTALL_CONTAINER_IMAGE=1
        if [ -d /home/fab3/prod/dae_env_cems_ess3K/ess3000_6.1.0.0_0315-22_dae_ppc64le.dir ]; then
            /home/fab3/csc-dev/ESS3kAutomation/SearchVersion/create_conteiner.sh DataAccess
        else
            cd "/home/fab3/prod/dae_env_cems_ess3K/"
            tar zxvf $tar_version_dae
            cd "/home/fab3/prod/dae_env_cems_ess3K/"
            yes Y | sh ess3000_6.1.0.0_0315-22_dae_ppc64le.sh
            /home/fab3/csc-dev/ESS3kAutomation/SearchVersion/create_conteiner.sh DataAccess
        fi
    elif [ "$datatype" = "DataManagement" ]; then
        export INSTALL_CONTAINER_IMAGE=1
        if [ -d /home/fab3/prod/DME_env_cems_ess3K/ess3000_6.1.0.0_0315-22_dme_ppc64le.dir]; then
            /home/fab3/csc-dev/ESS3kAutomation/SearchVersion/create_conteiner.sh DataManagement
        else
        cd "/home/fab3/prod/DME_env_cems_ess3K/"
        tar zxvf $tar_version_dme
        cd "/home/fab3/prod/dae_env_cems_ess3K/"
        yes Y | sh ess3000_6.0.1.2_1204-18_dme.sh  --silent 
        /home/fab3/csc-dev/ESS3kAutomation/SearchVersion/create_conteiner.sh DataManagement
        fi
    else
        echo "-----------------------------------"
        echo "Incorrect choice for the version"
        echo "--------------------------------------"
    fi
}

if [ $ls_podman_images -eq 2 ]; then
    #there is a container
    echo -e "${GREEN}already images is install \n${ENDCOLOR}"
    if [ $ls_podman_container -eq 2 ]; then
        echo -e "${YELLOW}It deleting the container \n${ENDCOLOR}" 
        podman stop $name_conteiner
        sleep 1
        podman rm -f $name_conteiner
        sleep 1
        echo -e "${GREEN}Container eliminated!${ENDCOLOR}"
        echo "---------------------------------------------"
        echo "---------------------------------------------"
        echo -e "${YELLOW}It going to install the version: $1 ${ENDCOLOR}"
        create_container $1
    else
        echo "Container doesn't exist"
        create_container $1
    fi
else
    echo -e "${YELLOW}---------------------------------------------"
    echo -e "          No hay contenedor creado"
    echo -e "---------------------------------------------"
    echo -e "Se comenzara a crear el contenedor para la Version $1 ${ENDCOLOR}"
    create_container $1    
fi