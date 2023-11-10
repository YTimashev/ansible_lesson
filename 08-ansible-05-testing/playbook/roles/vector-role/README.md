vector-role
=========
v1.0.0

Роль выполняет:
1. Скачивание Vector
2. Установка Vector

Requirements
------------

1. Ubuntu ОС
2. БД Clickhouse.

Role Variables
--------------

`defaults/main.yml`:
Версия Vector для установки:   
```yaml
vector_version: "0.25.2"
```

Dependencies
------------
Ссылка на роль Clickhouse `ansible-clickhouse`: https://github.com/AlexeySetevoi/ansible-clickhouse  
(или аналогичная по функционалу роль).

Example Playbook
----------------

Пример добавление роли в playbook:  
```yaml
- name: Install Vector
  hosts: vector
  roles:
    - role: vector-role
```      

License
-------

BSD
