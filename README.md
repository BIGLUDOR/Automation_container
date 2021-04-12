# Automation_container
This Test Automation is to create container and check if files or folders exist.
The Automation find the container image, verify if has attached images or some container created.

## About Project
We this solution resolve some activities to reduce time and reduce errors like choose the system version.

### Technologies used
1. Shell Script
2. Python (Web Scraping)
3. Podman


# Autamtion Test
First the app going to do scraping in a web page after that get some information about the system like: model, SO version, Order Number, with that information the app already knows what version install.
The app search the folders and check if those exist if don't exist descompress .tar and install the container.

The app also has to know what network brigde needs to install and that information is saved in a file .YML
