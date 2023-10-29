```
tim@tim:~/nl/devops-netology/ansible/08-ansible-03-yandex/playbook$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] ****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
The authenticity of host '62.84.116.57 (62.84.116.57)' can't be established.
ED25519 key fingerprint is SHA256:TjNu5xZqDPQmiMA94GDubn+/7nZYHdWax56WUJV5SDI.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]

TASK [Get clickhouse noarch distrib] *****************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse static distrib (rescue)] ********************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] *******************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP *******************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   

tim@tim:~/nl/devops-netology/ansible/08-ansible-03-yandex/playbook$ 
```