# Выпускной проект курса DevOps образовательной платформы OTUS

## Тема: Разворачивание инфраструктуры проекта базы знаний Wiki.js и создание процесса непрерывной интеграции приложения с использованием практик и инструментов DevOps

Имеем следующую схему проекта.
![Schema](images/schema.png)

Конфигурация проекта:
- 3 виртуальные машины GCP: web, cicd, monitoring. Для каждой виртуальной машины выделено свой внешний IP адрес.
- На каждой виртуальной машине установлен Docker.
- На сервере web установлены контейнеры NGINX, Node.js, MongoDB и exporter
- На сервере cicd установлен GitlabCI.
- На сервере monitoring установлен Prometheus  для сбора статистики и Grafana для визуализации графиков.

---

## Процесс

1. [x] Разворачивание инфраструктуры виртуальных машин с использованием Terraform
2. [x] Установка Docker и необходимого ПО, разворачиванием первичной инфраструктуры контейнеров с помощью Ansible и docker-compose файлов.
3. [x] Настройка Gitlab CI/CD
4. [ ] Настройка pipeline проекта. Настройка test / stage / prod сред.
5. [ ] Развертывание системы мониторинга Prometheus
6. [ ] Развертывание и настройка визуализации метрики в Grafana
7. [ ] Проверка целостности системы

---

Подготовка.
1. Учётная запись Google Cloud Platform.
2. Сервисный аккаунт Google. .json файл для работы с Ansible необходимо разместить в директори `ansible`.

Используемые версии используемых инструментов проекта:
1. Terraform 0.12.18
2. Ansible 2.9.4
3. Docker на виртуальный машинах 19.03.4, docker-compose 3

---

## Terraform

Для разворачивания инфраструктуры будем использовать Terraform. Для разворачивания инфраструктуры виртуальных машин конфигурации проекта в корне проекта переходим в директорию `terraform` и выполним команду `terraform apply`. Подтверждаем создание инфраструктуры и дожидаемся завершения.

## Ansible

После разворачивания инфраструктуры выполняем разворачивание контейнеров. Переходим в `ansible`, выполняем команду `ansible-playbook playbook/common.yml`.

## CI/CD

1. После старта машин переходим по внешнему IP виртуальной машины *cicd* и попадает в веб-интерфейс. Вводим пароль для пользователя root и логинимся в систему. Далее нажимаем на логотип гаечного инструмента > *Settings* > *Sign-up restrictions* > снимаем галку *Sign-up enabled* > *Save changes*.
2. Создадим группу проектов: *Groups* > *Your groups* > *New group* > вводим имя группы и описание. Здесь же создаём проект *New project* > задаём имя проекта и сохраняем. Сразу добавим публичный ключ к аккаунту на *Gitlab*: нажимаем на логотип учетной записи *Gitlab* > *Settings* > *SSH Keys* > добавляем публичный ssh-ключ. В `~/.ssh/config` на локальной машине добавляем следующую запись для работы с репозиторием по ssh.
```
Host gitlab
	Hostname 35.240.9.196
	User git
	Port 2222
	IdentityFile /home/<username>/.ssh/id_rsa
```
В директории репозитория создадим файл [.gitlab-ci.yml](ansible/files/cicd/.gitlab-ci.yml) и разместим в нем следующий *pipeline*.
```
add pipeline here
```
Файл `.gitlab-ci.yml` необходимо загрузить в удаленный репозиторий.
```
git checkout -b gitlab-ci
git add .gitlab-ci.yml
git commit -m "add pipeline file"
git push --set-upstream origin gitlab-ci
```
3. Перейдем во вкладку *Settings* > *CI/CD* > *Runners* > в открывшимся окне скопируем токен регистрации.
4. Для регистрации gitlab-runner выполним следующую команду.
```
docker exec -it cicd_gitlab-runner_1 gitlab-runner register --run-untagged --locked=false
```
```
Runtime platform                                    arch=amd64 os=linux pid=13 revision=ce065b93 version=12.10.1
Running in system-mode.                            
                                                   
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://<EXTERNAL_VM_IP>/
Please enter the gitlab-ci token for this runner:
<PASTE_TOKEN_HERE>
Please enter the gitlab-ci description for this runner:
[gitlab-runner.ru]: my-runner
Please enter the gitlab-ci tags for this runner (comma separated):
linux,xenial,ubuntu,docker
Registering runner... succeeded                     runner=GsxDxZ19
Please enter the executor: shell, docker-ssh+machine, virtualbox, docker+machine, kubernetes, custom, docker, docker-ssh, parallels, ssh:
docker
Please enter the default Docker image (e.g. ruby:2.6):
alpine:latest
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded! 
```

## Prometheus + Grafana

## Источники:
1. [Managing MongoDB on docker with docker-compose](https://medium.com/faun/managing-mongodb-on-docker-with-docker-compose-26bf8a0bbae3)
2. [Secured MongoDB container](https://medium.com/@MaxouMask/secured-mongodb-container-6b602ef67885)
3. [Create a docker-compose file for fully running gitlab](https://gitlab.com/gitlab-org/gitlab-foss/-/issues/50851)
4. [How To Build Docker Images and Host a Docker Image Repository with GitLab](https://www.digitalocean.com/community/tutorials/how-to-build-docker-images-and-host-a-docker-image-repository-with-gitlab)
5. [Automatically build and push Docker images using GitLab CI](https://angristan.xyz/2018/09/build-push-docker-images-gitlab-ci/)
6. [A gitlab-ci config to deploy to your server via ssh](https://medium.com/@hfally/a-gitlab-ci-config-to-deploy-to-your-server-via-ssh-43bf3cf93775)