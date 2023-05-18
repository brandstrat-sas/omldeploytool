![Diagrama deploy tool](./ansible/png/omnileads_logo_1.png)

## 100% Open-Source Contact Center Software

[Community Forum](https://forum.omnileads.net/)

# OMniLeads Deploy Tools

This repository provides different methods to run OMniLeads:

#### docker-compose :fast_forward:  🐳 

To launch the application on your workstation (MAC, Linux, Windows) or generic linux host, ideal to obtain an instance of
the application practically without configuration.

[docker-compose](docker-compose/README.md)

#### Ansible automation :office: :ok:

To launch the application using Ansible on any modern Linux instance with [Podman](https://docs.podman.io/en/latest/) or [Docker-Engine](https://docker.com/) support.
Under this format, hundreds of instances of the application can be managed using Ansible.

[Ansible](systemd/README.md)

#### development-environment :sunflower: :notes: :dizzy:

To lanunch the OMniLeads development stack and  start coding !  

[DevEnv](develoment-env/README.md)