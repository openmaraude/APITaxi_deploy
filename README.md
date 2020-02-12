Ansible playbooks and roles to deploy the infrastructure behind APITaxi.

# Usage

The inventory file inventory.yml is encrypted with `ansible-vault`. To run playbooks, create the file `~/vault_password_openmaraude` and ask for the password to someone from the team.

To deploy the infrastructure, first install Ansible dependencies:

```
$> ansible-galaxy install -r requirements.yml
```

Then run the playbook:

```
$> ansible-playbook -i inventory.yml site.yml
```

To deploy code, run:

```
$>  ansible-playbook -i inventory.yml deploy.yml -e '{
        api_taxi: {deploy: true},
        api_taxi_front: {deploy: true},
        api_taxi_swagger: {deploy: true},
        geotaxi: {deploy: true},
        map: {deploy: true}
    }'
```

To update the inventory:

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

#### APITaxi workers

Workers are disabled on the slave because they require write access to redis. You can enable and restart them manually, or preferably redeploy with `ansible-playbook -i inventory.yml deploy.yml -e '{api_taxi: {deploy: true}}'`.

#### Networking

IPv4 and IPv6 need to be moved to the server. Run the script `/opt/openmaraude/network/move-failover-ips.sh`.

#### APIs configuration

APIs are using services (PostgreSQL, redis, fluent, ...) installed on the same server. No configuration change should be necessary.

#### Backup

Barman is still trying to backup the old master. Edit `postgresql.master` in `inventory.yml` and run role `barman`.

#### Influxdb


From the backup server taxis03, delete the target database and restore it from the latest backup:

```
$> ssh taxis03.api.taxi
# Credentials are stored in inventory.yml. To check, run `ansible-vault view inventory.yml`
#> influx -host 10.0.0.2 -username xxx -password yyy -execute 'drop database taxis_prod'
# Here, 10.0.0.1 is backup to restore, 10.0.0.2 is the host where to restore the backup
#> influxd restore -portable -host 10.0.0.2:8088 /data/influx_backups/10.0.0.1/<latest backup>
```

Then, make sure to update taxis03 crontabs to backup the new server instead of the failing one.

# PostgreSQL backups

PostgreSQL is backup with barman. To list backups, run `barman list-backup pg` from taxis03.api.taxi.

To explore the concent of a backup, run the following commands:

```
# Display backup details
$> barman show-backup pg <backup id>
$> barman recover pg <backup id> /var/lib/barman/mybackup

# From another shell
docker run --rm -ti --name wip postgres:10

# From first shell, get postgresql.conf and pg_hba from a standard image
$> cd /var/lib/barman/mybackup
$> docker cp wip:/var/lib/postgresql/data/postgresql.conf .
$> docker cp wip:/var/lib/postgresql/data/pg_hba.conf .

# Quit docker from the first shell, then run a PostgreSQL container with the backup as data directory
$> docker run --rm -ti --name mybackup -v /var/lib/barman/mybackup/:/var/lib/postgresql/data/ postgres:10

# Connect to PostgreSQL from another shell
$> docker exec -ti mybackup psql -U postgres
```
