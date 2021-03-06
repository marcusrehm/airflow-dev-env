# Apache Airflow develop environment
#### A simple container to run Apache Airflow on Windows machines.

The main goal is create a minimal setup where Airflow can be hosted on Windows machines. This docker image has Airflow 1.9 installed using `pip install apache-airflow[crypto,postgres,hive,jdbc]` and running with SequentialExecutor and `SQLite` as backend.

Besides that oracle instant client 11g is also installed.

Tested on Windows 7, Windows 10 and Ubuntu 14.02 LTS.

This project is based on [docker-airflow](https://github.com/puckel/docker-airflow) image which is a great work.

# Getting Started
The image has four volumes:
- `usr/local/airflow/lib`: Should be mapped to the directory in your host machine where are the modules you use in dags are located.
- `usr/local/airflow/plugins`: Should be mapped to the plugins directory in your host machine.
- `usr/local/airflow/dags`: Should be mapped to the dags directory in your host machine.
- `usr/local/airflow/db`: Used to store `SQLite` database. If you need to remove the container or rebuild image, data (variable, connections, etc) used to develop and test is saved. 
- Fernet Key can be configured in `.env` file. If it not exits a new key will be created.

If you are running it on Ubuntu you'll need to give write access to docker group to folders in your local machine where you mapped volumes above. 

# Build and Test
```
docker build --rm -t marcusrehm/airflow-dev-env .
```

# Contribute
Feel free to fork, improve and PR.