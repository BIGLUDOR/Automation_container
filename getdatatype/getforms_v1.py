'''This is the caller to the API endpoint for the Forms application hosted in IBM Intranet.
Simply run
    python3 /home/fab3/csc-dev/api/getforms.py
It will print all the data from the following stages:
    Stage4. Inicio de pruebas
    Stage5. Pruebas
    Stage6. Soporte Ingenieria
And it will do it in the following syntax
    {cems}|{order}|{version}'''

#Version 3.0 by Ing. Rodolfo Rodriguez Alonso
#Este codigo permite autentificarte a FEB Order Tracking de CSC, extrae la metada en formato json, filtra y obtiene los campos definidos para mostrarlos en pantalla. Se puede ejecutar main2.py > file.txt para guardar la informacion.

from json import loads
import requests
import getpass
import sys

#URL con definicion de estado del item y esperando obtener un state el cual se logra al asignar {0}
URLstage5 =  "URL"
URLstage4 =  "URL"
URLsopEng =  "URL"

#defines el metada en formato json y cargas los datos de forms en json
user = sys.argv[1]
password = sys.argv[2]

def print_json_data(json_data):
    forms = loads(json_data)

    for ess in forms.get('items'):
        gems = ess.get('F_DropDown12')
        order = ess.get('O_rden')
        version = ess.get('F_DropDown3')
        modelo = ess.get('M_odelo')
        #Parsing the container to the respective gemsle3k
        if len(gems) < 4:
            dict_gems = {
            'C1' : 'gemsle3k-01',
            'C2' : 'gemsle3k-02',
            'C3' : 'gemsle3k-03',
            'C4' : 'gemsle3k-04',
            'C5' : 'gemsle3k-05',
            'C6' : 'gemsle3k-06',
            'C7' : 'gemsle3k-07',
            'C8' : 'gemsle3k-08',
            'C9' : 'gemsle3k-09',
            'C10' : 'gemsle3k-10',
            'C11' : 'gemsle3k-11',
            'C12' : 'gemsle3k-12',
            'C13' : 'gemsle3k-13',
	        'C14' : 'gemsle3k-14',
            'C15' : 'gemsle3k-15',
            'C16' : 'gemsle3k-16',
            'C17' : 'gemsle3k-17',
            'C18' : 'gemsle3k-18',
            'J1' : 'gemsle5k-1',
            'J2' : 'gemsle5k-2',
            'J3' : 'gemsle5k-3',
            'J4' : 'gemsle5k-4',
            'J5' : 'gemsle5k-5',
            'J6' : 'gemsle5k-6',
            'J7' : 'gemsle5k-7',
            'J8' : 'gemsle5k-8',
            'J9' : 'gemsle5k-9',
            'J10' : 'gemsle5k-10',
            'J11' : 'gemsle5k-11',
            'J12' : 'gemsle5k-12',
            'J13' : 'gemsle5k-13',
	        'J14' : 'gemsle5k-14',
            'J15' : 'gemsle5k-15',
            'J16' : 'gemsle5k-16',
            'J17' : 'gemsle5k-17',
            'J18' : 'gemsle5k-18'
            }
            cems=dict_gems.get(gems, gems)
            print(f'{cems}|{order}|{version}')

#Filtrar la busqueda del metadata json de Forms con los ST_NewStage y con un for ejecutas la busqueda con cada uno de estos ST_NewStage


def get_forms_datastage4(user, password):

        response = requests.get(URLstage4, auth=(user, password))
        if response.status_code == 200:
            json_data = response.content
            print(print_json_data(json_data))
        else:
            print(f"Error calling the API: {response.status_code} -> {response.content}")

def get_forms_datastage5(user, password):

        response = requests.get(URLstage5, auth=(user, password))
        if response.status_code == 200:
            json_data = response.content
            print(print_json_data(json_data))
        else:
            print(f"Error calling the API: {response.status_code} -> {response.content}")

def get_forms_soporteEng(user, password):
        response = requests.get(URLsopEng, auth=(user, password))
        if response.status_code == 200:
            json_data = response.content
            print(print_json_data(json_data))
        else:
            print(f"Error calling the API: {response.status_code} -> {response.content}")

if __name__ == '__main__':
    try:
        get_forms_datastage4(user, password)
        get_forms_datastage5(user, password)
        get_forms_soporteEng(user, password)
    except OSError as err:
        print("Unexpected error:", sys.exc_info()[0])
