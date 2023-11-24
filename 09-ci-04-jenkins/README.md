# Домашнее задание к занятию 10 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
>Создана инфраструктура из двух хостов в Yandex Cloud при помощи [Terraform](terraform) 
```console
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_jenkins-agent-01 = "158.160.110.132"
external_ip_address_jenkins-master-01 = "158.160.125.128"
```

2. Установить Jenkins при помощи playbook.
>Устанавливаем  Jenkins `$ ansible-playbook -i infrastructure/inventory/cicd/hosts.yml site.yml`
```console
tim@tim:~/nl/devops-netology/ansible/09-ci-04-jenkins/infrastructure$ ansible-playbook -i inventory/cicd/hosts.yml site.yml

PLAY [Preapre all hosts] *************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************
The authenticity of host '158.160.127.169 (158.160.127.169)' can't be established.
ED25519 key fingerprint is SHA256:V7wU5ykp2SkH8D184MkHJ4p8v51Q3miQZedJDCOt7lY.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? ok: [jenkins-master-01]
yes
ok: [jenkins-agent-01]

TASK [Create group] ******************************************************************************************************************
ok: [jenkins-agent-01]
ok: [jenkins-master-01]

TASK [Create user] *******************************************************************************************************************
ok: [jenkins-agent-01]
ok: [jenkins-master-01]

TASK [Install JDK] *******************************************************************************************************************
ok: [jenkins-agent-01]
ok: [jenkins-master-01]

PLAY [Get Jenkins master installed] **************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************
ok: [jenkins-master-01]

TASK [Get repo Jenkins] **************************************************************************************************************
ok: [jenkins-master-01]

TASK [Add Jenkins key] ***************************************************************************************************************
changed: [jenkins-master-01]

TASK [Install epel-release] **********************************************************************************************************
ok: [jenkins-master-01]

TASK [Install Jenkins and requirements] **********************************************************************************************
changed: [jenkins-master-01]

TASK [Ensure jenkins agents are present in known_hosts file] *************************************************************************
# 158.160.127.169:22 SSH-2.0-OpenSSH_7.4
# 158.160.127.169:22 SSH-2.0-OpenSSH_7.4
# 158.160.127.169:22 SSH-2.0-OpenSSH_7.4
# 158.160.127.169:22 SSH-2.0-OpenSSH_7.4
# 158.160.127.169:22 SSH-2.0-OpenSSH_7.4
changed: [jenkins-master-01] => (item=jenkins-agent-01)
[WARNING]: Module remote_tmp /home/jenkins/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when
running as another user. To avoid this, create the remote_tmp dir with the correct permissions manually

TASK [Start Jenkins] *****************************************************************************************************************
changed: [jenkins-master-01]

PLAY [Prepare jenkins agent] *********************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************
The authenticity of host '158.160.127.169 (158.160.127.169)' can't be established.
ED25519 key fingerprint is SHA256:V7wU5ykp2SkH8D184MkHJ4p8v51Q3miQZedJDCOt7lY.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [jenkins-agent-01]

TASK [Add master publickey into authorized_key] **************************************************************************************
changed: [jenkins-agent-01]

TASK [Create agent_dir] **************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Add docker repo] ***************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install some required] *********************************************************************************************************
changed: [jenkins-agent-01]

TASK [Update pip] ********************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install Ansible] ***************************************************************************************************************

changed: [jenkins-agent-01]

TASK [Reinstall Selinux] *************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Add local to PATH] *************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Create docker group] ***********************************************************************************************************
ok: [jenkins-agent-01]

TASK [Add jenkinsuser to dockergroup] ************************************************************************************************
changed: [jenkins-agent-01]

TASK [Restart docker] ****************************************************************************************************************
changed: [jenkins-agent-01]

TASK [Install agent.jar] *************************************************************************************************************
changed: [jenkins-agent-01]

PLAY RECAP ***************************************************************************************************************************
jenkins-agent-01           : ok=17   changed=11   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
jenkins-master-01          : ok=11   changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

tim@tim:~/nl/devops-netology/ansible/09-ci-04-jenkins/infrastructure$ 
```
3. Запустить и проверить работоспособность.
```bash
tim@tim:~/nl/devops-netology/ansible/09-ci-04-jenkins/infrastructure$ ssh centos@51.250.79.237
The authenticity of host '51.250.79.237 (51.250.79.237)' can't be established.
ED25519 key fingerprint is SHA256:VaRUcl+/lmiw1FFn3udR/6wO3WL2BM1J9VOnzGIjdTA.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Failed to add the host to the list of known hosts (/home/tim/.ssh/known_hosts.d/51.250.79.237).
[centos@fhmmqulu3fqds4hic45n ~]$ sudo su
[root@fhmmqulu3fqds4hic45n centos]# cat /var/lib/jenkins/secrets/initialAdminPassword
90ddff8d35304132b998902c547f1698
[root@fhmmqulu3fqds4hic45n centos]# 
```
4. Сделать первоначальную настройку.
![1](src/j1.png)

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
