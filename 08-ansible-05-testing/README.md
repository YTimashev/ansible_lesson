# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"` и драйвера `pip3 install molecule_docker molecule_podman`.
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing$ molecule --version
molecule 6.0.2 using python 3.10 
    ansible:2.14.4
    delegated:3.5.2 from molecule
    default:6.0.2 from molecule
    docker:2.1.0 from molecule_docker requiring collections: community.docker>=3.0.2 ansible.posix>=1.4.0
    podman:2.0.3 from molecule_podman requiring collections: containers.podman>=1.7.0 ansible.posix>=1.3.0
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing$ 
```

2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing$ docker image ls | grep aragast
aragast/netology     latest    b453a84e3f7a   12 months ago   2.46GB
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing$ 
```


## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.

<details>
<summary>Вывод команды molecule `test -s centos_7`</summary>

```console
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse$ molecule test -s centos_7
INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/tim/.cache/ansible-compat/7e099f/modules:/home/tim/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/tim/.cache/ansible-compat/7e099f/collections:/home/tim/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/tim/.cache/ansible-compat/7e099f/roles:/home/tim/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > dependency
INFO     Running from /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse : ansible-galaxy collection install -vvv community.docker:>=3.0.2
INFO     Running from /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse : ansible-galaxy collection install -vvv ansible.posix:>=1.4.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > lint
COMMAND: yamllint .
ansible-lint
flake8

WARNING  Listing 79 violation(s) that are fatal
fqcn[action-core]: Use FQCN for builtin module actions (set_fact).
handlers/main.yml:3 Use `ansible.builtin.set_fact` or `ansible.legacy.set_fact` instead.

schema[meta]: $.galaxy_info.min_ansible_version 2.8 is not of type 'string'. See https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#using-role-dependencies
meta/main.yml:1  Returned errors will not include exact line numbers, but they will mention
the schema name being used as a tag, like ``schema[playbook]``,
``schema[tasks]``.

This rule is not skippable and stops further processing of the file.

If incorrect schema was picked, you might want to either:

* move the file to standard location, so its file is detected correctly.
* use ``kinds:`` option in linter config to help it pick correct file type.


fqcn[action-core]: Use FQCN for builtin module actions (include_role).
molecule/centos_7/converge.yml:5 Use `ansible.builtin.include_role` or `ansible.legacy.include_role` instead.

fqcn[action-core]: Use FQCN for builtin module actions (assert).
molecule/centos_7/verify.yml:8 Use `ansible.builtin.assert` or `ansible.legacy.assert` instead.

fqcn[action-core]: Use FQCN for builtin module actions (include_role).
molecule/centos_8/converge.yml:5 Use `ansible.builtin.include_role` or `ansible.legacy.include_role` instead.

fqcn[action-core]: Use FQCN for builtin module actions (assert).
molecule/centos_8/verify.yml:8 Use `ansible.builtin.assert` or `ansible.legacy.assert` instead.

schema[inventory]: $.all None is not of type 'object'. See https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html
molecule/resources/inventory/hosts.yml:1  Returned errors will not include exact line numbers, but they will mention
the schema name being used as a tag, like ``schema[playbook]``,
``schema[tasks]``.

This rule is not skippable and stops further processing of the file.

If incorrect schema was picked, you might want to either:

* move the file to standard location, so its file is detected correctly.
* use ``kinds:`` option in linter config to help it pick correct file type.


fqcn[action-core]: Use FQCN for builtin module actions (include_role).
molecule/resources/playbooks/converge.yml:5 Use `ansible.builtin.include_role` or `ansible.legacy.include_role` instead.

fqcn[action-core]: Use FQCN for builtin module actions (include_role).
molecule/ubuntu_focal/converge.yml:5 Use `ansible.builtin.include_role` or `ansible.legacy.include_role` instead.

fqcn[action-core]: Use FQCN for builtin module actions (assert).
molecule/ubuntu_focal/verify.yml:8 Use `ansible.builtin.assert` or `ansible.legacy.assert` instead.

fqcn[action-core]: Use FQCN for builtin module actions (set_fact).
tasks/configure/db.yml:2 Use `ansible.builtin.set_fact` or `ansible.legacy.set_fact` instead.

jinja[spacing]: Jinja2 spacing could be improved: clickhouse-client -h 127.0.0.1 --port {{ clickhouse_tcp_secure_port | default(clickhouse_tcp_port) }}{{' --secure' if clickhouse_tcp_secure_port is defined else '' }} -> clickhouse-client -h 127.0.0.1 --port {{ clickhouse_tcp_secure_port | default(clickhouse_tcp_port) }}{{ ' --secure' if clickhouse_tcp_secure_port is defined else '' }} (warning)
tasks/configure/db.yml:2 Jinja2 template rewrite recommendation: `clickhouse-client -h 127.0.0.1 --port {{ clickhouse_tcp_secure_port | default(clickhouse_tcp_port) }}{{ ' --secure' if clickhouse_tcp_secure_port is defined else '' }}`.

no-free-form: Avoid using free-form when calling module actions. (set_fact)
tasks/configure/db.yml:2 Task/Handler: Set ClickHose Connection String

fqcn[action-core]: Use FQCN for builtin module actions (command).
tasks/configure/db.yml:5 Use `ansible.builtin.command` or `ansible.legacy.command` instead.

fqcn[action-core]: Use FQCN for builtin module actions (command).
tasks/configure/db.yml:11 Use `ansible.builtin.command` or `ansible.legacy.command` instead.

no-changed-when: Commands should not change things if nothing needs doing.
tasks/configure/db.yml:11 Task/Handler: Config | Delete database config

fqcn[action-core]: Use FQCN for builtin module actions (command).
tasks/configure/db.yml:20 Use `ansible.builtin.command` or `ansible.legacy.command` instead.

no-changed-when: Commands should not change things if nothing needs doing.
tasks/configure/db.yml:20 Task/Handler: Config | Create database config

fqcn[action-core]: Use FQCN for builtin module actions (template).
tasks/configure/dict.yml:2 Use `ansible.builtin.template` or `ansible.legacy.template` instead.

fqcn[action-core]: Use FQCN for builtin module actions (file).
tasks/configure/sys.yml:2 Use `ansible.builtin.file` or `ansible.legacy.file` instead.

fqcn[action-core]: Use FQCN for builtin module actions (file).
tasks/configure/sys.yml:17 Use `ansible.builtin.file` or `ansible.legacy.file` instead.

fqcn[action-core]: Use FQCN for builtin module actions (file).
tasks/configure/sys.yml:26 Use `ansible.builtin.file` or `ansible.legacy.file` instead.

fqcn[action-core]: Use FQCN for builtin module actions (template).
tasks/configure/sys.yml:35 Use `ansible.builtin.template` or `ansible.legacy.template` instead.

fqcn[action-core]: Use FQCN for builtin module actions (template).
tasks/configure/sys.yml:45 Use `ansible.builtin.template` or `ansible.legacy.template` instead.

fqcn[action-core]: Use FQCN for builtin module actions (template).
tasks/configure/sys.yml:54 Use `ansible.builtin.template` or `ansible.legacy.template` instead.

fqcn[action-core]: Use FQCN for builtin module actions (template).
tasks/configure/sys.yml:65 Use `ansible.builtin.template` or `ansible.legacy.template` instead.

fqcn[action-core]: Use FQCN for builtin module actions (template).
tasks/configure/sys.yml:76 Use `ansible.builtin.template` or `ansible.legacy.template` instead.

fqcn[action-core]: Use FQCN for builtin module actions (lineinfile).
tasks/configure/sys.yml:87 Use `ansible.builtin.lineinfile` or `ansible.legacy.lineinfile` instead.

fqcn[action-core]: Use FQCN for builtin module actions (apt_key).
tasks/install/apt.yml:5 Use `ansible.builtin.apt_key` or `ansible.legacy.apt_key` instead.

fqcn[action-core]: Use FQCN for builtin module actions (apt_repository).
tasks/install/apt.yml:12 Use `ansible.builtin.apt_repository` or `ansible.legacy.apt_repository` instead.

fqcn[action-core]: Use FQCN for builtin module actions (apt_repository).
tasks/install/apt.yml:20 Use `ansible.builtin.apt_repository` or `ansible.legacy.apt_repository` instead.

fqcn[action-core]: Use FQCN for builtin module actions (apt).
tasks/install/apt.yml:27 Use `ansible.builtin.apt` or `ansible.legacy.apt` instead.

fqcn[action-core]: Use FQCN for builtin module actions (apt).
tasks/install/apt.yml:36 Use `ansible.builtin.apt` or `ansible.legacy.apt` instead.

fqcn[action-core]: Use FQCN for builtin module actions (copy).
tasks/install/apt.yml:45 Use `ansible.builtin.copy` or `ansible.legacy.copy` instead.

risky-file-permissions: File permissions unset or incorrect.
tasks/install/apt.yml:45 Task/Handler: Hold specified version during APT upgrade | Package installation

fqcn[action-core]: Use FQCN for builtin module actions (rpm_key).
tasks/install/dnf.yml:5 Use `ansible.builtin.rpm_key` or `ansible.legacy.rpm_key` instead.

fqcn[action-core]: Use FQCN for builtin module actions (yum_repository).
tasks/install/dnf.yml:12 Use `ansible.builtin.yum_repository` or `ansible.legacy.yum_repository` instead.

fqcn[action-core]: Use FQCN for builtin module actions (dnf).
tasks/install/dnf.yml:24 Use `ansible.builtin.dnf` or `ansible.legacy.dnf` instead.

fqcn[action-core]: Use FQCN for builtin module actions (dnf).
tasks/install/dnf.yml:32 Use `ansible.builtin.dnf` or `ansible.legacy.dnf` instead.

fqcn[action-core]: Use FQCN for builtin module actions (yum_repository).
tasks/install/yum.yml:5 Use `ansible.builtin.yum_repository` or `ansible.legacy.yum_repository` instead.

fqcn[action-core]: Use FQCN for builtin module actions (yum).
tasks/install/yum.yml:16 Use `ansible.builtin.yum` or `ansible.legacy.yum` instead.

fqcn[action-core]: Use FQCN for builtin module actions (yum).
tasks/install/yum.yml:24 Use `ansible.builtin.yum` or `ansible.legacy.yum` instead.

fqcn[action-core]: Use FQCN for builtin module actions (include_vars).
tasks/main.yml:3 Use `ansible.builtin.include_vars` or `ansible.legacy.include_vars` instead.

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:14 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:14 Task/Handler: include_tasks precheck.yml

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:17 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:17 Task/Handler: include_tasks params.yml

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:20 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:20 Task/Handler: include_tasks file={{ lookup('first_found', params) }} apply={'tags': ['install'], '__line__': 23, '__file__': PosixPath('tasks/main.yml')}

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:32 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:32 Task/Handler: include_tasks file=configure/sys.yml apply={'tags': ['config', 'config_sys'], '__line__': 35, '__file__': PosixPath('tasks/main.yml')}

fqcn[action-core]: Use FQCN for builtin module actions (meta).
tasks/main.yml:39 Use `ansible.builtin.meta` or `ansible.legacy.meta` instead.

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:42 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:42 Task/Handler: include_tasks service.yml

fqcn[action-core]: Use FQCN for builtin module actions (wait_for).
tasks/main.yml:45 Use `ansible.builtin.wait_for` or `ansible.legacy.wait_for` instead.

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:51 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:51 Task/Handler: include_tasks file=configure/db.yml apply={'tags': ['config', 'config_db'], '__line__': 54, '__file__': PosixPath('tasks/main.yml')}

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:58 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:58 Task/Handler: include_tasks file=configure/dict.yml apply={'tags': ['config', 'config_dict'], '__line__': 61, '__file__': PosixPath('tasks/main.yml')}

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/main.yml:65 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/main.yml:65 Task/Handler: include_tasks file=remove.yml apply={'tags': ['remove'], '__line__': 68, '__file__': PosixPath('tasks/main.yml')}

fqcn[action-core]: Use FQCN for builtin module actions (set_fact).
tasks/params.yml:3 Use `ansible.builtin.set_fact` or `ansible.legacy.set_fact` instead.

fqcn[action-core]: Use FQCN for builtin module actions (set_fact).
tasks/params.yml:7 Use `ansible.builtin.set_fact` or `ansible.legacy.set_fact` instead.

fqcn[action-core]: Use FQCN for builtin module actions (command).
tasks/precheck.yml:1 Use `ansible.builtin.command` or `ansible.legacy.command` instead.

fqcn[action-core]: Use FQCN for builtin module actions (fail).
tasks/precheck.yml:5 Use `ansible.builtin.fail` or `ansible.legacy.fail` instead.

fqcn[action-core]: Use FQCN for builtin module actions (file).
tasks/remove.yml:3 Use `ansible.builtin.file` or `ansible.legacy.file` instead.

fqcn[action-core]: Use FQCN for builtin module actions (include_tasks).
tasks/remove.yml:15 Use `ansible.builtin.include_tasks` or `ansible.legacy.include_tasks` instead.

name[missing]: All tasks should be named.
tasks/remove.yml:15 Task/Handler: include_tasks remove/{{ ansible_pkg_mgr }}.yml

fqcn[action-core]: Use FQCN for builtin module actions (apt).
tasks/remove/apt.yml:5 Use `ansible.builtin.apt` or `ansible.legacy.apt` instead.

fqcn[action-core]: Use FQCN for builtin module actions (apt_repository).
tasks/remove/apt.yml:12 Use `ansible.builtin.apt_repository` or `ansible.legacy.apt_repository` instead.

fqcn[action-core]: Use FQCN for builtin module actions (apt_key).
tasks/remove/apt.yml:18 Use `ansible.builtin.apt_key` or `ansible.legacy.apt_key` instead.

fqcn[action-core]: Use FQCN for builtin module actions (dnf).
tasks/remove/dnf.yml:5 Use `ansible.builtin.dnf` or `ansible.legacy.dnf` instead.

fqcn[action-core]: Use FQCN for builtin module actions (yum_repository).
tasks/remove/dnf.yml:12 Use `ansible.builtin.yum_repository` or `ansible.legacy.yum_repository` instead.

fqcn[action-core]: Use FQCN for builtin module actions (rpm_key).
tasks/remove/dnf.yml:19 Use `ansible.builtin.rpm_key` or `ansible.legacy.rpm_key` instead.

fqcn[action-core]: Use FQCN for builtin module actions (yum).
tasks/remove/yum.yml:5 Use `ansible.builtin.yum` or `ansible.legacy.yum` instead.

fqcn[action-core]: Use FQCN for builtin module actions (yum_repository).
tasks/remove/yum.yml:12 Use `ansible.builtin.yum_repository` or `ansible.legacy.yum_repository` instead.

fqcn[action-core]: Use FQCN for builtin module actions (service).
tasks/service.yml:3 Use `ansible.builtin.service` or `ansible.legacy.service` instead.

name[template]: Jinja templates should only be at the end of 'name'
tasks/service.yml:3 Task/Handler: Ensure {{ clickhouse_service }} is enabled: {{ clickhouse_service_enable }} and state: {{ clickhouse_service_ensure }}

jinja[spacing]: Jinja2 spacing could be improved: deb http://repo.yandex.ru/clickhouse/{{ansible_distribution_release}} stable main -> deb http://repo.yandex.ru/clickhouse/{{ ansible_distribution_release }} stable main (warning)
vars/debian.yml:4 Jinja2 template rewrite recommendation: `deb http://repo.yandex.ru/clickhouse/{{ ansible_distribution_release }} stable main`.

Read documentation for instructions on how to ignore specific rule violations.

                       Rule Violation Summary                       
 count tag                    profile    rule associated tags       
     2 jinja[spacing]         basic      formatting (warning)       
     1 no-free-form           basic      syntax, risk               
     1 schema[inventory]      basic      core                       
     1 schema[meta]           basic      core                       
     9 name[missing]          basic      idiom                      
     1 name[template]         moderate   idiom                      
     1 risky-file-permissions safety     unpredictability           
     2 no-changed-when        shared     command-shell, idempotency 
    61 fqcn[action-core]      production formatting                 

Failed: 77 failure(s), 2 warning(s) on 65 files. Last profile that met the validation criteria was 'min'.
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > syntax

playbook: /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/resources/playbooks/converge.yml
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Create Dockerfiles from image names] *************************************
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Synchronization the context] *********************************************
changed: [localhost] => (item={'capabilities': ['SYS_ADMIN'], 'command': '/usr/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'env': {'ANSIBLE_USER': 'ansible', 'DEPLOY_GROUP': 'deployer', 'SUDO_GROUP': 'wheel', 'container': 'docker'}, 'image': 'centos:7', 'name': 'centos_7', 'privileged': True, 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item=None)
ok: [localhost]

TASK [Build an Ansible compatible image (new)] *********************************
changed: [localhost] => (item=molecule_local/centos:7)

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item=None)
ok: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=None)
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=5    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos_7]

TASK [Apply Clickhouse Role] ***************************************************
ERROR! the role 'ansible-clickhouse' was not found in /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/resources/playbooks/roles:/home/tim/.cache/molecule/clickhouse/centos_7/roles:/home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles:/home/tim/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse:/home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/resources/playbooks

The error appears to be in '/home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/resources/playbooks/converge.yml': line 7, column 15, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

      include_role:
        name: ansible-clickhouse
              ^ here

PLAY RECAP *********************************************************************
centos_7                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '-D', '--inventory', '/home/tim/.cache/molecule/clickhouse/centos_7/inventory', '--skip-tags', 'molecule-notest,notest', '/home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/resources/playbooks/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/tim/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/clickhouse$ 
```

</details>

> Не смотря на то что команда завершилась провалом, можно четко отследить практически всю цепочку тестов, которая позволяет выявить и исправить имеющиеся в большом количестве нарушений правил yaml и ansible, а также проанализировать и исправить ошибки.

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/vector-role$ molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/tim/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/vector-role/molecule/default successfully.
tim@tim:~/nl/devops-netology/ansible/08-ansible-05-testing/playbook/roles/vector-role$ 
```

3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
> Добавлены дистрибутивы: `centos:7`, `centos:8` и `ubuntu:latest` от [pycontribs](https://hub.docker.com/u/pycontribs)/
```yaml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: centos7
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
  - name: centos8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
  - name: ubuntu
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
```

4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.