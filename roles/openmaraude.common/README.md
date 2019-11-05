openmaraude.common
==================

This Ansible role installs common packages (eg. vim, screen) and debug packages (eg. lsof, tcpdump) that are installed on all servers behind APITaxi.

Usage
-----

Create a file `playbook.yml`:

```
---
- name: Common
  hosts: all
  gather_facts: no
  roles:
    - role: openmaraude.common
```

Create a file `inventory.ini` with the target address.

Run `ansible-playbook -i inventory.ini playbook.yml`.


Run tests
---------

This role is tested with [molecule](https://molecule.readthedocs.io/en/stable/).

* To install molecule, run `pip install 'molecule[docker]'`.
* To run the full tests suite, run `molecule test`, or `molecule test --destroy=never` to prevent test server from being destroyed in case of error.
* To develop on this role, run `molecule coverage`. Run `molecule login` to get the shell on the server, and `molecule destroy` when your changes are done.
