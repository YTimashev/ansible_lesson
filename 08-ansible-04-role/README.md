# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. Созданы два пустых публичных репозитория: vector-role и lighthouse-role.
 > Репозитории: [vector-role ](https://github.com/YTimashev/vector-role.git) и [lighthouse-role](https://github.com/YTimashev/lighthouse-role.git)
2. Создана инфраструктура из трех хостов в Yandex Cloud при помощи Terraform 

**Что сделано**

1. В старой версии playbook создан файл `requirements.yml` , в который зазместили следующий код:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

> [requirements.yml](playbook/requirements.yml)

2. При помощи `ansible-galaxy` скачал себе эту роль.
```
tim@tim:~/nl/devops-netology/ansible/08-ansible-04-role/playbook$ ansible-galaxy install -p roles -r requirements.yml
Starting galaxy role install process
The authenticity of host 'github.com (140.82.121.3)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
- extracting clickhouse to /home/tim/nl/devops-netology/ansible/08-ansible-04-role/playbook/roles/clickhouse
- clickhouse (1.13) was installed successfully
tim@tim:~/nl/devops-netology/ansible/08-ansible-04-role/playbook$ 
```
> Скачанная роль [ansible-galaxy](playbook/roles/clickhouse)

3. Созданы новые каталоги с ролями при помощи `ansible-galaxy role init vector-role`и `ansible-galaxy role init  lighthouse-role`
```
tim@tim:~/nl/devops-netology/ansible/08-ansible-04-role/playbook/roles$ ansible-galaxy role init vector-role
- Role vector-role was created successfully
tim@tim:~/nl/devops-netology/ansible/08-ansible-04-role/playbook/roles$ ansible-galaxy role init lighthouse-role
- Role lighthouse-role was created successfully
tim@tim:~/nl/devops-netology/ansible/08-ansible-04-role/playbook/roles$ 
```
4. На основе tasks из старого playbook заполнена новая role. Разнесены переменные между `vars` и `default`. 
5. Перенесены нужные шаблоны конфигов в `templates`.
6. В файлах `README.md` описаны обе роли и их параметры. 
>Ссылка на [README.md](playbook/roles/vector-role/README.md) vector-role
>Ссылка на [README.md](playbook/roles/lighthouse-role/README.md) lighthouse-role

7. Обе roles выложены в репозитории. Проставлены теги, с использованием семантической нумерацией. Добавлены roles в `requirements.yml` в playbook.
>Ссылка на репозиторий [vector-role](https://github.com/YTimashev/vector-role.git) 
>Ссылка на репозиторий [lighthouse-role](https://github.com/YTimashev/lighthouse-role.git)

8. Переработан playbook на использование roles. Учтены зависимости LightHouse и возможности совмещения `roles` с `tasks`.
9. Выложен playbook в репозиторий.
>Ссылка на репозиторий [playbook](https://github.com/YTimashev/ansible_lesson/tree/main/08-ansible-04-role/playbook)

11. В ответах выше даны ссылки на оба репозитория с roles и ссылка на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
