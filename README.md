APITaxi_deploy gathers a set of Ansible playbook to deploy the infrastructure behind APITaxi.


USAGE
=====

Install Ansible:

```
# OSX
$> brew install ansible

# Ubuntu/debian
$> apt-get install ansible
```

The easiest way to test a playbook is to run it into a Docker container.

```
# Create the container
$> docker run --rm -ti --name test-deploy bash

# From another shell, create the inventory file and run the playbook
$> echo "test-deploy ansible_connection=docker" > inventory.ini
$> ansible-playbook -i inventory.ini bootstrap.yml
$> ansible-playbook -i inventory.ini deploy-api-taxi.yml
```
