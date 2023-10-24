# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
  >Отличная подача материала, доступно. Подписался.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
  >Использую [репозиторий](https://github.com/YTimashev/ansible_lesson.git) созданный в предыдущем домашнем задании
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
  >[Playbok]()
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.
  >В качестве инфраструктуры будe использовать Docker

```yml
#docker-compose.yml
---
version: '3'

services:
  clickhouse_vm:
    image: centos:7
    container_name: clickhouse-01
    restart: unless-stopped
    entrypoint: "sleep infinity"
    ports:cd
      - "9000:9000"
      - "8123:8123"
    tty: true

  vector_vm:
    image: centos:7
    container_name: vector-01
    restart: unless-stopped
    entrypoint: "sleep infinity"
    ports:
      - "8383:8383"
      - "8686:8686"
    tty: true
...
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
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
```yml
- name: Install Vector #установка vector
  hosts: vector
  handlers:
    - name: Start vector service
      ansible.builtin.service:
        name: vector
        enabled: true
        state: restarted
  tasks:
    - name: Download distrib #скачиваем архив vector
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
        dest: "/vector-{{ vector_version }}.tar.gz" # каталог со скаченным архивом
        mode: +rw
    - name: Create vector group #создаем группу 
      ansible.builtin.group:
        name: vector
    - name: Create vector user #создаем пользователя
      ansible.builtin.user:
        name: vector
        group: vector
    - name: Unpack vector distrib #распаковываем архив
      ansible.builtin.unarchive:
        src: "/vector-{{ vector_version }}.tar.gz"
        remote_src: true
        dest: "/home/vector"
        extra_opts: [--strip-components=2]
    - name: Install vector executable #Запуск иполняемого файла
      ansible.builtin.copy:
        src: "{{ item.src }}"
        remote_src: true
        dest: "{{ item.dest }}"
        mode: "{{ item.mode }}"
      loop:
        - { src: "/home/vector/bin/vector", dest: "/usr/bin/vector", mode: "+x" }
        - { src: "/home/vector/etc/systemd/vector.service", dest: "/usr/lib/systemd/system/vector.service", mode: "" }
      notify: Start vector service
    - name: Create vector directories  #создание директории 
      ansible.builtin.file:
        path: "{{ item }}"
        state: directory
        owner: "vector"
        mode: "0755"
      loop:
        - "{{ vector_datadir }}"
        - "/home/vector/test"
        - "/etc/vector"
    - name: Install vector configuration #настройка конфигурационных файлов c помощью jinja2
      ansible.builtin.template:
        src: vector.toml.j2
        dest: "/etc/vector/vector.toml"
        mode: "0755"
      notify: Start vector service
  post_tasks:
    - name: Bring vector alive if docker restart
      ansible.builtin.service:
        name: vector
        state: started
      when: ansible_connection == "docker"
      tags:
        - docker
```



5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
   >После исправления ошибок (пустые строки, отстутсвие пробелов) получили следующий результат:
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ ansible-lint site.yml

Passed: 0 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'production'.
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ 
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
   > флагом `--check` проверяем playbook перед запуском на основной машине.
```
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ ansible-playbook  -i inventory/prod.yml site.yml --check

PLAY [Install sudo and systemctl] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [vector-01]
ok: [clickhouse-01]

TASK [Install sudo] ********************************************************************************************************************************************************************************************
changed: [clickhouse-01]
changed: [vector-01]

TASK [Install systemctl] ***************************************************************************************************************************************************************************************
changed: [vector-01]
changed: [clickhouse-01]

TASK [Ensure run directory for ansible check_systemd] **********************************************************************************************************************************************************
changed: [clickhouse-01]
changed: [vector-01]

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse noarch distrib] ***************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse static distrib (rescue)] ******************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "module_stderr": "/bin/sh: sudo: command not found\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}

PLAY RECAP *****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=6    changed=4    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

   >Произошел сбой на этапе установки clickhouse по причине отстутсвия в centos (rpm) пакета sudo.


7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

   >флаг `--diff` отражает информацию по производимым изменениям в системе
```
tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ ansible-playbook  -i inventory/prod.yml site.yml --diff

PLAY [Install sudo and systemctl] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]
ok: [vector-01]

TASK [Install sudo] ********************************************************************************************************************************************************************************************
changed: [vector-01]
changed: [clickhouse-01]

TASK [Install systemctl] ***************************************************************************************************************************************************************************************
changed: [clickhouse-01]
changed: [vector-01]

TASK [Ensure run directory for ansible check_systemd] **********************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/run/systemd/system/",
-    "state": "absent"
+    "state": "directory"
 }

changed: [clickhouse-01]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/run/systemd/system/",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse noarch distrib] ***************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse static distrib (rescue)] ******************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Configure clickhouse host bind] **************************************************************************************************************************************************************************
--- before
+++ after: /home/tim/nl/devops-netology/ansible/08-ansible-02-playbook/playbook/files/clickhouse.yml
@@ -0,0 +1 @@
+listen_host: 0.0.0.0

changed: [clickhouse-01] => (item={'src': 'clickhouse.yml', 'dest': '/etc/clickhouse-server/config.d/all-hosts.yml'})
--- before
+++ after: /home/tim/nl/devops-netology/ansible/08-ansible-02-playbook/playbook/files/logger.yml
@@ -0,0 +1,13 @@
+---
+profiles:
+  default:
+    date_time_input_format: best_effort
+
+users:
+  logger:
+    password: "logger"
+    networks:
+      ip: "::/0"
+    profile: default
+    quota: default
+    access_management: 0

changed: [clickhouse-01] => (item={'src': 'logger.yml', 'dest': '/etc/clickhouse-server/users.d/logger.yml'})

RUNNING HANDLER [Start clickhouse service] *********************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Bring clickhouse alive if docker restart] ****************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] *****************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create tables] *******************************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Download distrib] ****************************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create vector group] *************************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create vector user] **************************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Unpack vector distrib] ***********************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Install vector executable] *******************************************************************************************************************************************************************************
changed: [vector-01] => (item={'src': '/home/vector/bin/vector', 'dest': '/usr/bin/vector', 'mode': '+x'})
changed: [vector-01] => (item={'src': '/home/vector/etc/systemd/vector.service', 'dest': '/usr/lib/systemd/system/vector.service', 'mode': ''})

TASK [Create vector directories] *******************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "owner": 0,
+    "owner": 1000,
     "path": "/var/lib/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01] => (item=/var/lib/vector)
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "owner": 0,
+    "owner": 1000,
     "path": "/home/vector/test",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01] => (item=/home/vector/test)
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "owner": 0,
+    "owner": 1000,
     "path": "/etc/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01] => (item=/etc/vector)

TASK [Install vector configuration] ****************************************************************************************************************************************************************************
--- before
+++ after: /home/tim/.ansible/tmp/ansible-local-98959qenl8qtw/tmpruxi4qh1/vector.toml.j2
@@ -0,0 +1,24 @@
+# Set global options
+data_dir = "/var/lib/vector"
+
+# Vector's API (disabled by default)
+# Enable and try it out with the `vector top` command
+[api]
+enabled = true
+address = "0.0.0.0:8686"
+
+[sources.test_log]
+type = "file"
+ignore_older_secs = 600
+include = [ "/home/vector/test/*.log" ]
+read_from = "beginning"
+
+[sinks.docker_clickhouse]
+type = "clickhouse"
+inputs = [ "test_log" ]
+database = "logs"
+endpoint = "http://clickhouse-01:8123"
+table = "file_log"
+compression = "gzip"
+auth = { user = "logger", password = "logger", strategy = "basic" }
+skip_unknown_fields = true
\ No newline at end of file

changed: [vector-01]

RUNNING HANDLER [Start vector service] *************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Bring vector alive if docker restart] ********************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=12   changed=9    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=14   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ 
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
 tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ ansible-playbook  -i inventory/prod.yml site.yml --diff

PLAY [Install sudo and systemctl] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [vector-01]
ok: [clickhouse-01]

TASK [Install sudo] ********************************************************************************************************************************************************************************************
ok: [clickhouse-01]
ok: [vector-01]

TASK [Install systemctl] ***************************************************************************************************************************************************************************************
ok: [clickhouse-01]
ok: [vector-01]

TASK [Ensure run directory for ansible check_systemd] **********************************************************************************************************************************************************
ok: [clickhouse-01]
ok: [vector-01]

PLAY [Install Clickhouse] **************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse noarch distrib] ***************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse static distrib (rescue)] ******************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *****************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Configure clickhouse host bind] **************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item={'src': 'clickhouse.yml', 'dest': '/etc/clickhouse-server/config.d/all-hosts.yml'})
ok: [clickhouse-01] => (item={'src': 'logger.yml', 'dest': '/etc/clickhouse-server/users.d/logger.yml'})

TASK [Bring clickhouse alive if docker restart] ****************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] *****************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create tables] *******************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] ******************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Download distrib] ****************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create vector group] *************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create vector user] **************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Unpack vector distrib] ***********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector executable] *******************************************************************************************************************************************************************************
ok: [vector-01] => (item={'src': '/home/vector/bin/vector', 'dest': '/usr/bin/vector', 'mode': '+x'})
ok: [vector-01] => (item={'src': '/home/vector/etc/systemd/vector.service', 'dest': '/usr/lib/systemd/system/vector.service', 'mode': ''})

TASK [Create vector directories] *******************************************************************************************************************************************************************************
ok: [vector-01] => (item=/var/lib/vector)
ok: [vector-01] => (item=/home/vector/test)
ok: [vector-01] => (item=/etc/vector)

TASK [Install vector configuration] ****************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Bring vector alive if docker restart] ********************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *****************************************************************************************************************************************************************************************************
clickhouse-01              : ok=11   changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=13   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

tim@tim:~/nl/devops-netology/ansible/08-ansible-02-playbook/playbook$ 
```
   >Как видим playbook идемпотентен.

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
  >[README.md-файл](
11. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.
  > [Ссылка на PLAYBOOK](08-ansible-02-playbook/playbook)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
