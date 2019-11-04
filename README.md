Ansible playbooks to deploy the infrastructure behind APITaxi.

# Requirements

Install ansible on your computer:

```
# OSX
$> brew install ansible

# Debian/Ubuntu
$> apt-get install -y ansible
```

# Playbooks

## bootstrap.yml

Install required packages to run ansible on a Debian/Ubuntu server.

#### Usage example

```
# To test locally, create a Docker container
$> docker run --rm -ti --name deploy debian

# From another shell, create the inventory file and run the playbook
$> echo "deploy ansible_connection=docker" > inventory.ini
$> ansible-playbook -i inventory.ini bootstrap.yml
```

## common.yml

Install useful packages for any server. For example `ps`, `lsof`, `strace`, `curl`, ...

**require**: bootstrap.yml

#### Usage example

```
# To test locally, create a Docker container
$> docker run --rm -ti --name deploy debian

# From another shell, create the inventory file and run the playbook's dependencies and the playbook
$> ansible-playbook -i inventory.ini bootstrap.yml common.yml
```
