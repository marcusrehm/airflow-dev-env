FROM python:3.6-slim
LABEL Name=marcusrehm/airflow-dev-env Version=0.0.1 AUTHOR=MarcusRehm

ARG AIRFLOW_HOME=/usr/local/airflow
ARG AIRFLOW_VERSION=1.9

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Install Java
RUN apt-get update \
    && apt-get install -y openjdk-7-jre \
    && update-alternatives --config java \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && buildDeps=' \
        python3-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        python3-pip \
        python3-requests \
        apt-utils \
        curl \
        netcat \
        locales \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && python -m pip install -U pip setuptools wheel \
    && pip install Cython \
    && pip install pytz \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install azure-storage \
    && pip install apache-airflow[crypto,postgres,hive,jdbc]==$AIRFLOW_VERSION \
    && apt-get purge --auto-remove -yqq $buildDeps \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base \
        /root/.cache/pip/*

COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_HOME}

RUN mkdir ${AIRFLOW_HOME}/db
RUN chown -R airflow: ${AIRFLOW_HOME}/db

RUN chown -R airflow: /entrypoint.sh

EXPOSE 8080

USER airflow
WORKDIR ${AIRFLOW_HOME}

VOLUME ${AIRFLOW_HOME}/dags
VOLUME ${AIRFLOW_HOME}/db

ENTRYPOINT ["/entrypoint.sh"]
