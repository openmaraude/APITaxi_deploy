Ansible playbooks and roles to deploy the infrastructure behind APITaxi.

# Usage

The inventory file inventory.yml is encrypted with `ansible-vault`. To run playbooks, create the file `~/vault_password_openmaraude` and ask for the password to someone from the team.

To install servers, run:

```
$> ansible-playbook -i inventory.yml site.yml
```

To deploy code, run:

```
$>  ansible-playbook -i inventory.yml deploy.yml -e '{
        api_taxi: {deploy: true},
        api_taxi_front: {deploy: true},
        api_taxi_worker: {deploy: true},
        geotaxi: {deploy: true}
    }'
```

To play with inventory:

```
$> ansible-vault view inventory.yml
$> ansible-vault edit inventory.yml
```

# Notes

APITaxi infrastructure is made of three servers hosted on [Online.net](https://www.online.net):

- taxis01: "master" server hosting applications, PostgreSQL master and redis master
- taxis02: "slave" server hosting applications, PostgreSQL slave and redis slave
- taxis03: "admin" server with barman (to backup PostgreSQL)


# Failover

In case of master failure, failover is not automatic and manual intervention is required.

#### PostgreSQL

Run `/opt/openmaraude/postgresql/promote-slave.sh`.

#### Redis

Edit `inventory.yml`, set `redis.role` to `master` then run the role `redis`.

To achieve the same result manually, run `/opt/openmaraude/redis/switch-master.sh` to make the slave become master. To make the configuration permanent, edit `/etc/redis/redis.conf` and comment the `slaveof` directive.


#### api\_taxi\_worker

Service is disabled on the slave because it requires write access to redis. Enable and restart it:

```
systemctl enable api_taxi_worker
systemctl start api_taxi_worker
```

Instead, you can also redeploy `api_taxi_worker` with `ansible-playbook -i inventory.yml deploy.yml -e {api_taxi_worker: {deploy: true}}'`.

#### Networking

IPv4 and IPv6 need to be moved to the server. Run the script `/opt/openmaraude/network/move-failover-ips.sh`.

#### APIs configuration

APIs are using services (PostgreSQL, redis, fluent, ...) installed on the same server. No configuration change should be necessary.

#### Backup

Barman is still trying to backup the old master. Edit `postgresql.master` in `inventory.yml` and run role `barman`.