#!/usr/bin/env bash


function exampleMethodToCheckLog ()
{
  sleep 10
  tail -f /LOGS_LOCATION/LOG.log | while read LOGLINE
  do
      [[ "${LOGLINE}" == *"STRING TO WAIT"* ]] && pkill -P $$ tail
  done
}

function waitForSpringDataflow ()
{
  sleep 10
  tail -f /opt/des/spring-dataflow/logs/spring.log | while read LOGLINE
  do
      [[ "${LOGLINE}" == *"Started LocalDataFlowServer in"* ]] && pkill -P $$ tail
  done
  cd /home/dep; /usr/bin/psql -h postgres -U postgres -d dataflow -a -f fix-spring-dataflow-db.sql
}


function startCloudera ()
{
  su - dep -c "hadoop-daemon.sh start namenode"
  su - dep -c "hadoop-daemon.sh start datanode"
  su - dep -c "yarn-daemon.sh start resourcemanager"
  su - dep -c "yarn-daemon.sh start nodemanager"
  su - dep -c "mr-jobhistory-daemon.sh start historyserver"
  su - dep /opt/cloudera/spark/sbin/start-all.sh
  su - dep -c "export KAFKA_HEAP_OPTS=-Xmx512m; zookeeper-server-start.sh -daemon /etc/kafka/conf/zookeeper.properties"
  sleep 5
  su - dep -c "export KAFKA_HEAP_OPTS=-Xmx512m; kafka-server-start.sh -daemon /etc/kafka/conf/server.properties"
  sleep 2
  su - dep -c "hive --service metastore" &
  sleep 2
  if [ "${HIVE_DEBUGLOG}" = true ]; then
    su - dep -c "hive --service hiveserver2 --hiveconf hive.root.logger=DEBUG" &
  else
    su - dep -c "hive --service hiveserver2 --hiveconf hive.root.logger=INFO" &
  fi
  su - dep  /opt/cloudera/spark/sbin/start-history-server.sh
  if [ "${IMPALA}" = true ] || [ "${DES_INSIGHT}" = true ]; then
     echo 'starting impala'
     sleep 5
     su - dep /opt/cloudera/impala/impala-init.sh
     sleep 5
  fi
  su - dep -c "/opt/cloudera/kafka/bin/kafka-topics --zookeeper 127.0.0.1:2181 --create --replication-factor 1 --partition 1 --topic batchWorkflowEvents > /dev/null 2>&1"
  su - dep -c "/opt/cloudera/kafka/bin/kafka-topics --zookeeper 127.0.0.1:2181 --create --replication-factor 1 --partition 1 --topic batch-apps-heartbeat > /dev/null 2>&1"
}

function enableKerberos ()
{
   /etc/rc.d/init.d/krb5kdc start
   /etc/rc.d/init.d/kadmin start
   echo -e "des\ndes\n" | /usr/sbin/kadmin.local -q "addprinc dep/jobserver@JOBSERVER"; \
   echo -e "des\ndes\n" | /usr/sbin/kadmin.local -q "addprinc dep@JOBSERVER"; \
   echo -e "des\ndes\n" | /usr/sbin/kadmin.local -q "xst -k dep.keytab dep@JOBSERVER"; \
   echo -e "des\ndes\n" | /usr/sbin/kadmin.local -q "xst -k dep.jobserver.keytab dep/jobserver@JOBSERVER"; \
   mkdir -p /etc/security/keytabs/; \
   mv *keytab /etc/security/keytabs/; \
   chown -R dep:hadoop /etc/security/keytabs; \
   chmod 0700 /etc/security/keytabs/*
   su - dep -c "echo -e 'des\n' | /usr/bin/kinit -k -t /etc/security/keytabs/dep.keytab dep@JOBSERVER"
   su - dep -c "keytool -genkeypair -keystore jobserver.jks -keyalg RSA  -alias jobserver -dname 'CN=jobserver O=dep' -storepass changeme -keypass changeme2"
   cp /home/dep/resources/cloudera/krb_enabled/etc/hadoop/* /opt/cloudera/hadoop/etc/hadoop/
   cp /home/dep/resources/cloudera/krb_enabled/etc/hive/conf/*  /opt/cloudera/hive/conf/
   cp /home/dep/resources/cloudera/krb_enabled/etc/spark/* /opt/cloudera/spark/conf/
   cp /home/dep/resources/cloudera/krb_enabled/etc/spark/* /opt/cloudera/spark/lib/spark2/conf/
   cp /opt/des/jobserver/krb/application.properties /opt/des/jobserver/
   chown -R dep:hadoop /opt/cloudera/hadoop/etc/hadoop/
   chown -R dep:hadoop /opt/cloudera/hive/conf/
   chown -R dep:hadoop /opt/cloudera/spark/conf/
   chown -R dep:hadoop /opt/cloudera/spark/lib/spark2/conf/
   chown -R dep:hadoop /opt/des/jobserver/
}



function startJobserver ()
{
  if [ "${MOCK}" = true ]; then
    su - dep -c "echo 'starting job server with application-mockservcies.properties'"
    su - dep -c "cd /opt/des/jobserver; /usr/bin/java -Xms1024m -Xmx1024m -XX:+HeapDumpOnOutOfMemoryError -Dserver.port=8092 -Dspring.cloud.config.uri=http://config-server:8888 -Dspring.profiles.active=docker -Dlogging.path=/opt/des/jobserver/logs/ -Djasypt.encryptor.password=*ZGGF=Vfe4xfH%@F4?Kz -Dasync=true -Dspring.config.location=application-mockservices.properties -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=7272 -jar job-server.jar " &
    startMockService
  else
    su - dep -c "cd /opt/des/jobserver; /usr/bin/java -Xms1024m -Xmx1024m -XX:+HeapDumpOnOutOfMemoryError -Dserver.port=8092 -Dspring.cloud.config.uri=http://config-server:8888 -Dspring.profiles.active=docker -Dlogging.path=/opt/des/jobserver/logs/ -Djasypt.encryptor.password=*ZGGF=Vfe4xfH%@F4?Kz -Dasync=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=7272 -jar job-server.jar " &
  fi
}


########### to start impala  :    IMPALA_SHELL=/opt/cloudera/impala-shell/bin/impala-shell


###########################  Entry point #########################

#echo "* soft nproc 65000" > "/etc/security/limits.d/90-nproc.conf"
#echo "root soft nproc unlimited" >> "/etc/security/limits.d/90-nproc.conf"


if [ "$1" = "true" ]; then
    service sshd start
    startCloudera
    exit 0
fi

if [ "$2" != "buildTime" ]; then

  if [ "${KRB}" = true ]; then
      enableKerberos
  fi

  service sshd start
  startCloudera

  cd /etc/hadoop/conf
  sed -i -e 's/0.0.0.0/jobserver/g' core-site.xml
  echo '######################## READY ########################'
  while true; do sleep 5000; done
fi