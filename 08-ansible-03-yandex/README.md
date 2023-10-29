# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
>  Инфраструктура из трех хостов (centos-7) в Yandex Cloud развернута при помощи Terraform - [ссылка на код](/src)
```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_clickhouse = "158.160.99.82"
external_ip_address_lighthouse = "158.160.127.38"
external_ip_address_vector = "158.160.104.18"
```
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
>  Предыдущее задание было выполнено с помощью Docker, поэтому большую часть кода пришлось переделать.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
>  В коде активно применялись все вышеперечисленные модули: для скачивания пакетов `get_url`, для создания конфигурационных файлов из шаблонов `template`, пакетный менеджер`yum`(Clickhouse) и `apt` (vector, nginx, lighthouse), а также другие модули.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
```yml
- name: Install nginx                    # установка nginx
  hosts: lighthouse
  handlers:
    - name: Restart Nginx Service        # Хендлер на перезапуск nginx 
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  tasks:
    - name: Install nginx                # установка nginx при помощи пакетного менеджера apt
      become: true
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true
      notify: Restart nginx service

- name: Install lighthouse               # Установка lighthouse
  hosts: lighthouse
  handlers:
    - name: Restart nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  pre_tasks:
    - name: Install unzip                 # установка распаковщика/архиватора
      become: true
      ansible.builtin.apt:
        name: unzip
        state: present
        update_cache: true
  tasks:
    - name: Get lighthouse distrib         # скачиваем статику LightHouse
      ansible.builtin.get_url:
        url: "https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip"
        dest: "./lighthouse.zip"
        mode: "0644"
    - name: Unarchive lighthouse distrib into nginx # Распаковываем lighthouse в веб-сервер nginx
      become: true
      ansible.builtin.unarchive:
        src: ./lighthouse.zip
        dest: /var/www/html/
        remote_src: true
      notify: Restart nginx service
    - name: Make nginx config              # создание конфигурационного файла с помощью шаблона lighthouse.j2
      become: true
      ansible.builtin.template:
        src: lighthouse.j2
        dest: /etc/nginx/sites-enabled/default
        mode: "0644"
      notify: Restart nginx service        # перезапуск nginx
    - name: Remove lighthouse distrib      # удаление с хоста ранее скаченного архива lighthouse.zip
      ansible.builtin.file:
        path: "./lighthouse.zip"
        state: absent
```

4. Подготовьте свой inventory-файл `prod.yml`.
>  [Ссылка на inventory-файл `prod.yml`](inventory/prod.yml)
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
>  После исправления ошибок (пустые строки, отстутсвие пробелов, кавычек, установки прав доступа) получили следующий результат:
```bash
tim@tim:~/nl/devops-netology/ansible/08-ansible-03-yandex/playbook$ ansible-lint site.yml 

Passed: 0 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'production'.
tim@tim:~/nl/devops-netology/ansible/08-ansible-03-yandex/playbook$ 
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
>  [ansible-playbook -i inventory/prod.yml site.yml --check](src2/check.md)
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
>  [ansible-playbook -i inventory/prod.yml site.yml --diff](src2/diff.md)
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
>  Повторно [ansible-playbook -i inventory/prod.yml site.yml --check](src2/check.md)
>  Playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.
>  
---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
