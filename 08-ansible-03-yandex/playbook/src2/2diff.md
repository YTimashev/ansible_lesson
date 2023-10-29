```
tim@tim:~/nl/devops-netology/ansible/08-ansible-03-yandex/playbook$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
The authenticity of host '158.160.99.82 (158.160.99.82)' can't be established.
ED25519 key fingerprint is SHA256:jkpAs1j2DDYK0PVBjGAesa/cRgaHl8i3BVtUz7qRL0A.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]

TASK [Get clickhouse noarch distrib] *****************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse static distrib (rescue)] ********************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *******************************************************************************************************************
ok: [clickhouse-01]

TASK [Start clickhouse service] **********************************************************************************************************************
ok: [clickhouse-01]

TASK [Clickhouse. Waiting while clickhouse-server is available...] ***********************************************************************************
Pausing for 30 seconds (output is hidden)
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
ok: [clickhouse-01]

TASK [Create database] *******************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
The authenticity of host '158.160.104.18 (158.160.104.18)' can't be established.
ED25519 key fingerprint is SHA256:vIWLSqj1n471Uzb92EOiFxetDK0YlyqdYxJOAiWgCpc.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [vector-01]

TASK [Get vector distrib] ****************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ***********************************************************************************************************************
ok: [vector-01]

PLAY [Install nginx] *********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
The authenticity of host '158.160.127.38 (158.160.127.38)' can't be established.
ED25519 key fingerprint is SHA256:T47x49QZjpc0WeU3cvA74YL10lwg+lttld4o6xBY2J8.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [lighthouse-01]

TASK [Install nginx] *********************************************************************************************************************************
ok: [lighthouse-01]

PLAY [Install lighthouse] ****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [lighthouse-01]

TASK [Install unzip] *********************************************************************************************************************************
ok: [lighthouse-01]

TASK [Get lighthouse distrib] ************************************************************************************************************************
changed: [lighthouse-01]

TASK [Unarchive lighthouse distrib into nginx] *******************************************************************************************************
ok: [lighthouse-01]

TASK [Make nginx config] *****************************************************************************************************************************
ok: [lighthouse-01]

TASK [Remove lighthouse distrib] *********************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "./lighthouse.zip",
-    "state": "file"
+    "state": "absent"
 }

changed: [lighthouse-01]

PLAY RECAP *******************************************************************************************************************************************
clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=8    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

tim@tim:~/nl/devops-netology/ansible/08-ansible-03-yandex/playbook$ 
```