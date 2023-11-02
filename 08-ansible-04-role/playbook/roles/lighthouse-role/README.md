lighthouse-role
=========

Роль производит:  
1. Установку веб-сервера nginx  
2. Скачивание с git-репозитория Lighthouse и его накатку в вебсервер  
3. Создание конфигурационного файла nginx для доступа к ресурсам Lighthouse  
4. Запуск веб-сервера nginx  

Requirements
------------

1. Ubuntu ОС
2. БД Clickhouse  

Role Variables
--------------

`vars/main.yml`:  
Содержит в параметрах ссылку на git-репозитория Lighthouse с исходным кодом :     
```yaml
lighthouse_src: "https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip"
```

`defaults/main.yml`:  
Порт веб-сервера:     
```yaml
llighthouse_port: "80"
```

`templates/lighthouse.j2`
Конфигурационный файл nginx
```
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html/lighthouse-master;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files $uri $uri/ =404;
        }
}
```

Dependencies
------------
Ссылка на роль Clickhouse `ansible-clickhouse`: https://github.com/AlexeySetevoi/ansible-clickhouse  


Example Playbook
----------------

 Добавление роли в playbook:  
```yaml
- name: Install Lighthouse
  hosts: lighthouse
  roles:
    - role: lighthouse-role
```


License
-------

BSD
