import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_docker_container_running(host):
    service = host.service('api-taxi')
    assert service.is_enabled
    assert service.is_running


def test_uwsgi_socket_exists(host):
    f = host.file('/var/run/openmaraude/api-taxi.sock')
    assert f.exists
