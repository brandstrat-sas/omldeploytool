![Diagrama deploy tool](./systemd/png/omnileads_logo_1.png)

## 100% Open-Source Contact Center Software

[Community Forum](https://forum.omnileads.net/)

# OMniLeads Deploy Tools

This repository provides different methods to run OMniLeads:

#### Systemd :office: :ok:

To launch the application using systemd on any modern Linux instance with [Podman](https://docs.podman.io/en/latest/) support.
This format is very similar to the method used in [OMniLeads 1.X](https://documentacion-omnileads.readthedocs.io/es/develop/install_omlapp.html#about-install-onpremise). 

[systemd](systemd/README.md)

#### docker-compose :fast_forward:  🐳 

To launch the application on your workstation (MAC, Linux, Windows) or generic linux host, ideal to obtain an instance of
the application practically without configuration. This format is purely for Labs & testing. 

[docker-compose](docker-compose/README.md)

#### development-environment :sunflower: :notes: :dizzy:

To lanunch the OMniLeads development stack and  start coding !  

[DevEnv](develoment-env/README.md)