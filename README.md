# Выпускной проект курса DevOps

Имеем следующую схему проекта.
![Schema](schema.png)

Конфигурация проекта:
- 3 виртуальные машины GCP: web, cicd, monitoring. Для каждой виртуальной машины выделено свой внешний IP адрес.
- На каждой виртуальной машине установлен Docker.
- На сервере web установлены контейнеры NGINX, Node.js, MongoDB и exporter
- На сервере cicd установлен GitlabCI.
- На сервере monitoring установлен Prometheus  для сбора статистики и Grafana для визуализации графиков.

---

## Terraform

Для разворачивания инфраструктуры будет использовать Terraform.

## Источники:
1. [Managing MongoDB on docker with docker-compose](https://medium.com/faun/managing-mongodb-on-docker-with-docker-compose-26bf8a0bbae3)
2. [Secured MongoDB container](https://medium.com/@MaxouMask/secured-mongodb-container-6b602ef67885)