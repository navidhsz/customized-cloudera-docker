FROM centos:6.9

MAINTAINER "navid.hsz"

USER root

EXPOSE 5432

ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_USER=postgres
ENV PGDATA=/var/lib/pgsql/9.4/data


     #postgres installation
RUN  mkdir -p /var/lib/pgsql/data; \
     mkdir -p /opt/postgres; \
     cd /opt/postgres; \
     curl -v -L -b -O https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-3.noarch.rpm > pgdg-centos94-9.4-3.noarch.rpm; \
     rpm -ivh pgdg-centos94-9.4-3.noarch.rpm; \
     yum -y install postgresql94 postgresql94-server; \
     service postgresql-9.4 initdb; \
     echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf; \
     echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf; \
     mkdir -p /pgsql/data; \
     chmod -R 0700 /pgsql; \
     chown -R postgres:postgres /pgsql

COPY resources/postgres/pg_hba.conf /var/lib/pgsql/9.4/data/
COPY resources/postgres/postgresql.conf /var/lib/pgsql/9.4/data/
COPY resources/postgres/pg_hba.conf /var/lib/pgsql/data/
COPY resources/postgres/postgresql.conf /var/lib/pgsql/data/
COPY resources/cloudera/5.11.1/hive/postgres/* /tmp/

RUN  chown -R postgres.postgres /var/lib/pgsql; \
     chown -v postgres.postgres /var/lib/pgsql/9.4/data/postgresql.conf; \
     chown -v postgres.postgres /var/lib/pgsql/9.4/data/pg_hba.conf; \
 	 chown -v postgres.postgres /var/lib/pgsql/data/postgresql.conf; \
     chown -v postgres.postgres /var/lib/pgsql/data/pg_hba.conf; \
 	 chmod -R 777 /var/lib/pgsql; \
 	 #increase column size in metasote for Hive.
     echo 'ALTER TABLE "public"."COLUMNS_V2" ALTER COLUMN "TYPE_NAME" TYPE TEXT;' >> /tmp/hive-schema-1.1.0.postgres.sql

USER postgres

RUN  /usr/pgsql-9.4/bin/pg_ctl initdb -D /pgsql/data/; \
     sleep 2; \
     mkdir -p /pgsql/data/hive_space; \
     mkdir -p /pgsql/data/jobserver_space; \
     mkdir -p /pgsql/data/codeserver_space; \
     mkdir -p /pgsql/data/workflow_space; \
     mkdir -p /pgsql/data/dataflow_space; \
     mkdir -p /pgsql/data/schemaregistry_space; \
     chmod 0777 /pgsql/data/hive_space; \
     chmod 0777 /pgsql/data/jobserver_space; \
     chmod 0777 /pgsql/data/codeserver_space; \
     chmod 0777 /pgsql/data/workflow_space; \
     chmod 0777 /pgsql/data/dataflow_space; \
     cp -r /var/lib/pgsql/9.4/data/pg_hba.conf /pgsql/data/; \
     cp -r /var/lib/pgsql/9.4/data/postgresql.conf /pgsql/data/; \
     /usr/pgsql-9.4/bin/pg_ctl reload -D /pgsql/data/; \
     sleep 2; \
     /usr/pgsql-9.4/bin/pg_ctl -D /pgsql/data/ -w start; \
     #Hive metastore
     /usr/bin/psql -h 127.0.0.1 -U postgres -w -c "CREATE TABLESPACE hivespace LOCATION '/pgsql/data/hive_space'"; \
     /usr/bin/psql -h 127.0.0.1 -U postgres -w -c 'CREATE DATABASE hive TABLESPACE hivespace'; \
     cd /tmp; \
     /usr/bin/psql -h 127.0.0.1 -U postgres -d hive -a -f hive-schema-1.1.0.postgres.sql
   #  /usr/pgsql-9.4/bin/pg_ctl -D /pgsql/data -w start

USER root

EXPOSE 5432

COPY resources/init.sh /opt/

RUN chmod +x /opt/init.sh

ENTRYPOINT /opt/init.sh

