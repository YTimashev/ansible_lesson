# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
  >Отличная подача материала, доступно. Подписался.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
  >Использую [репозиторий](https://github.com/YTimashev/ansible_lesson.git) созданный в предыдущем домашнем задании
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
  >[Playbok]()
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ docker run --name clickhouse-01 -dit pycontribs/centos:7 sleep infinity
3f8d07ab07aa38e4e2264505db818feffa15e17897f6ecf5c12411e74d7c43f7

tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ docker run --name vector-01 -dit pycontribs/centos:7 sleep infinity
a18fc6511acf965e8b9e198ff164b9bbd07fc551c0e1943c6ce3681e8a242b29

tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ docker ps
CONTAINER ID   IMAGE                 COMMAND            CREATED          STATUS          PORTS     NAMES
a18fc6511acf   pycontribs/centos:7   "sleep infinity"   27 seconds ago   Up 24 seconds             vector-01
3f8d07ab07aa   pycontribs/centos:7   "sleep infinity"   3 minutes ago    Up 3 minutes              clickhouse-01
```

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
```yml
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: docker
vector:
  hosts:
    vector-01:
      ansible_connection: docker 
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
```yml
- name: Install Vector
  hosts: vector
  handlers:
    - name: Start Vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Get Vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/0.21.1/vector-0.21.1-1.{{ ansible_architecture }}.rpm"
        dest: "./vector-0.21.1-1.{{ ansible_architecture }}.rpm"
        mode: 0755
    - name: Install Vector packages
      become: true
      ansible.builtin.yum:
        name: vector-0.21.1-1.{{ ansible_architecture }}.rpm
      notify: Start Vector service
    - name: Deploy config Vector
      ansible.builtin.template:
        src: vector.j2
        dest: /etc/vector/vector.toml
        mode: 0755
      notify: Start Vector service
```

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```bash
WARNING: PATH altered to include /usr/bin
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ ansible-playbook  -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] ********************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************************************

TASK [Delay 5 sec] ***************************************************************************************************************
Pausing for 5 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [Create database] ***********************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] ************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************
ok: [vector-01]

TASK [Get Vector distrib] ********************************************************************************************************
changed: [vector-01]

TASK [Install Vector packages] ***************************************************************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'vector-0.21.1-1.x86_64.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'vector-0.21.1-1.x86_64.rpm' found on system"]}

PLAY RECAP ***********************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
vector-01                  : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ ansible-playbook  -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ********************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************************************

TASK [Delay 5 sec] ***************************************************************************************************************
Pausing for 5 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [Create database] ***********************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "cmd": ["clickhouse-client", "-q", "create database logs;"], "delta": "0:00:00.398585", "end": "2023-05-19 19:13:17.008742", "failed_when_result": true, "msg": "non-zero return code", "rc": 210, "start": "2023-05-19 19:13:16.610157", "stderr": "Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)", "stderr_lines": ["Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)"], "stdout": "", "stdout_lines": []}

PLAY RECAP ***********************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ ansible-playbook  -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ********************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************************************

TASK [Delay 5 sec] ***************************************************************************************************************
Pausing for 5 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [Create database] ***********************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "cmd": ["clickhouse-client", "-q", "create database logs;"], "delta": "0:00:00.398585", "end": "2023-05-19 19:13:17.008742", "failed_when_result": true, "msg": "non-zero return code", "rc": 210, "start": "2023-05-19 19:13:16.610157", "stderr": "Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)", "stderr_lines": ["Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)"], "stdout": "", "stdout_lines": []}

PLAY RECAP ***********************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```

  >Не понимаю что я неправильно делаю. почему отказ в подключении к БД.
  
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
