#!/bin/bash

# This is the script which calls the API to retrieve and parse the data from FORMS to our local server.
# It needs an SSH connection to the jump-server "going merry" to be able to connect to IBM intranet where FORMS is hosted

hostname=$(hostname)
# hostname="gemsle3k-07"

byellow="\033[1;93m"
green="\033[1;92m"
red="\033[1;31m"
reset="\033[0;0m"

#local run
#/home/ess5k/scripts/forms/api
# cemslist=$(cat api/getforms.txt)
echo "Ingresa tu correo de W3"
read user
echo "Ingresa tu password"
read -s pass
#cemslist=$(ssh 10.10.10.252 python3 getforms_v1.py $user $pass )
#cemslist=$(ssh 10.10.10.252  python3 getforms_v1.py $user $pass)
cemslist=$(ssh 10.10.10.252  python3 /home/fab3/csc-dev/ESS3kAutomation/getdatatype/getforms_v1.py $user $pass)
if [ $? -ne 0 ]; then 
    echo "-----------------------------------------------------"
    echo "contraseña erronea, por favor de verificar"
    echo "                    y/o               "
    echo "Verifica que el CEMS o JEMS tenga una orden"
    echo "-----------------------------------------------------"
    exit 
fi
#filtering cemslist
actualcems=$(grep -e "${hostname}|" <<< "${cemslist}")
IFS='|' read -ra CEMS <<< $actualcems
if [ -z "$actualcems" ]
then
  echo "--------------------------------------------------------------------------------------------------"
  echo -e "${red} ERROR : Forms no encontro una orden a procesar en ${hostname}, favor de validar.${reset}"
  echo "--------------------------------------------------------------------------------------------------"
  exit
else
  #getting the version block
  #IFS='|' read -ra CEMS <<< $actualcems
  echo "----------------------------------------------------------------------------------------------------------------------------"
  echo -e "${byellow} En el ${CEMS[0]} ${reset} se deberá procesar la orden ${byellow}${CEMS[1]}${reset} con la versión ${red} ${CEMS[2]} ${reset}"
  echo "----------------------------------------------------------------------------------------------------------------------------"
fi
echo "${CEMS[1]}-${CEMS[2]}" > orden-version.txt
#-------------------------------------------------
#-------------------------------------------------
#call the script "rm_container.sh".
typedata=$(printf '%s' ${CEMS[2]})
echo $typedata
/home/fab3/csc-dev/ESS3kAutomation/SearchVersion/rm_container.sh $typedata
#/home/fab3/csc-dev/ESS3k_scripts_luis/search_version/rm_container.sh $typedata
#Create conections with network and create the container.
#eliminate the old brigde


