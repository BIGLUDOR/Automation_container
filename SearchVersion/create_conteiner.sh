#!/bin/sh
#create by Luis Armando López
#this script can search the bridge and delete also can do new bridge with the correct number of cems.
#-------------------colors--------------------
RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
#-------------------brigde--------------------
brigdeAccess=$(nmcli c s | grep dmg | awk '{print $1}')
brigdemgmt=$(nmcli c s | grep mgmt | awk '{print $1}')
number_gems=$(hostname | awk 'split($0, a, "0") {print a[2]}')
hostname_cems=$(hostname -s)
pathdae="/home/fab3/prod/dae_env_cems_ess3K/ess3000_6.1.0.0_0315-22_dae_ppc64le.dir/"
pathdme="/home/fab3/prod/DME_env_cems_ess3K/ess3000_6.1.0.0_0315-22_dme_ppc64le.dir/"

function delete_brigde () {
    #Down brigde with the name
    if [ "$1" = "DataAccess" ]; then
        #nmcli c down $brigdeAccess
        #after we can delete the brigde
        #nmcli c delete $brigdeAccess
        nmcli c down mgmt_bridge
        nmcli c delete mgmt_bridge
    elif [ "$1" = "DataManagement" ]; then
        nmcli c down $brigdemgmt
        #after we can delete the brigde
        nmcli c delete $brigdemgmt
    else
        echo -e "${RED}There isn't version to delete brigde \n${ENDCOLOR}"
    fi

}

function network_brige () {
    #command to create the network in the container
    ./essmgr -n -c "$1essmgr${hostname_cems}.yml"
    echo "Se comenzara a instalar el conetenedor..."
    ./essmgr -r -c "$1essmgr${hostname_cems}.yml"
}

if [ "$1" = "DataAccess" ]; then 
    cd "$pathdae"
    if [ -e "essmgr${hostname_cems}.yml" ]; then
        ./essmgr -f *.tar -i -b
        echo -e "it going to delete bridge ${brigdename} \n"
        delete_brigde DataAccess
        echo -e "It going to install .YML \n"
        network_brige $pathdae
    else 
        echo -e "\n"
        echo "Doesn't exist YML file"
    fi

elif [ "$1" = "DataManagement" ]; then
    cd "$pathdme"
    if [ -e "essmgr${hostname_cems}.yml" ]; then 
        echo "Se eliminara el bridges ${brigdename}"
        delete_brigde DataManagement
        echo "Se instalara el archivo .YML"
        network_brige $pathdme
    else
        echo -e "\n"
        echo "Doesn't exist YML file"
    fi
else
    echo -e "\n"
    echo "Error: It doesn't find the version"
fi