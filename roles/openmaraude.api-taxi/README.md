openmaraude.api-taxi
====================

Install [APITaxi](https://github.com/openmaraude/APITaxi) in a Docker container.

Usage
-----

Create a file `playbook.yml`:

```
---
- name: APITaxi
  hosts: all
  become: true
  gather_facts: yes
  roles:
    - role: openmaraude.api-taxi
```

Create a file `inventory.ini` with the target address.

Install dependencies with `ansible-playbook install -r molecule/default/requirements.yml`.

Run `ansible-playbook -i inventory.ini playbook.yml`.


Run tests
---------

This role is tested with [molecule](https://molecule.readthedocs.io/en/stable/).

* To install molecule, run `pip install 'molecule[vagrant]'`.
* To run the full tests suite, run `molecule test`, or `molecule test --destroy=never` to prevent test server from being destroyed in case of error.
* To develop on this role, run `molecule coverage`. Run `molecule login` to get the shell on the server, and `molecule destroy` when your changes are done.
