FROM com.navidhsz.data/jdk8:latest

MAINTAINER "navid.hsz"

USER root

EXPOSE 21050
EXPOSE 50070
EXPOSE 50075
EXPOSE 8080
EXPOSE 8088
EXPOSE 18081
EXPOSE 18080
EXPOSE 10000
EXPOSE 50010
EXPOSE 9000
EXPOSE 9092
EXPOSE 8020
EXPOSE 4040
EXPOSE 8042
EXPOSE 2222

ENV LD_LIBRARY_PATH=/opt/cloudera/native:/usr/java/jdk1.8.0_201-amd64/jre/lib/amd64/server
ENV HADOOP_HOME=/opt/cloudera/hadoop
ENV HIVE_HOME=/opt/cloudera/hive
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV SPARK_HOME=/opt/cloudera/spark
ENV YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop

ENV HADOOP_YARN_HOME=${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_HOME=${HADOOP_HOME}
ENV KAFKA_HOME=/opt/cloudera/kafka/lib/kafka
ENV IMPALA_HOME=/opt/cloudera/impala

ENV SPARK_SCALA_VERSION=2.11
ENV PATH=${PATH}:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${HIVE_HOME}/bin:${KAFKA_HOME}/bin:/opt/cloudera/impala



COPY resources/ssh/sshd_config /etc/ssh/

RUN groupadd hadoop; \
    adduser -G hadoop dep; \
    echo 'hadoop' | passwd dep --stdin; \
    usermod -aG wheel dep; \
    service sshd restart; \
    cd /opt; \
    mkdir -p /etc/kafka/conf; \
    mkdir -p /etc/impala/conf; \
    mkdir -p cloudera/hadoop/logs; \
    mkdir -p cloudera/hive/logs; \
    mkdir -p cloudera/spark/logs; \
    mkdir -p cloudera/kafka/logs; \
    mkdir -p cloudera/native; \
    mkdir -p cloudera/impala/logs; \
    mkdir -p cloudera/impala-shell/logs; \
    mkdir -p cloudera/hbase; \
    mkdir -p cloudera/sentry; \
    mkdir cloudera/kafka/zookeeper; \
    mkdir -p /opt/resources; \
    mkdir -p /var/run/hdfs-sockets; \
    chown -R dep:hadoop /var/run/hdfs-sockets; \

    curl -v -L -b -O "http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.6.0-cdh5.11.1.tar.gz" > hadoop-2.6.0-cdh5.11.1.tar.gz; \
    curl -v -L -b -O "http://archive.cloudera.com/cdh5/cdh/5/hive-1.1.0-cdh5.11.1.tar.gz" > hive-1.1.0-cdh5.11.1.tar.gz; \
    curl -v -L -b -O "http://archive.cloudera.com/spark2/parcels/2.1.0.cloudera1/SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904-el6.parcel" > SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904-el6.parcel; \
    curl -v -L -b -O "http://archive.cloudera.com/kafka/parcels/2.1.1/KAFKA-2.1.1-1.2.1.1.p0.18-el6.parcel" > KAFKA-2.1.1-1.2.1.1.p0.18-el6.parcel; \
    curl -v -L -b -O "http://archive.cloudera.com/cdh5/cdh/5/hbase-1.2.0-cdh5.11.1.tar.gz" > hbase-1.2.0-cdh5.11.1.tar.gz; \
    curl -v -L -b -O "http://archive.cloudera.com/cdh5/cdh/5/sentry-1.5.1-cdh5.11.1.tar.gz" > sentry-1.5.1-cdh5.11.1.tar.gz; \

    curl -v -L -b -O "http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/5.11.1/RPMS/x86_64/impala-2.8.0+cdh5.11.1+0-1.cdh5.11.1.p0.6.el6.x86_64.rpm" > impala-2.8.0+cdh5.11.1+0-1.cdh5.11.1.p0.6.el6.x86_64.rpm; \
    curl -v -L -b -O "http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/5.11.1/RPMS/x86_64/impala-shell-2.8.0+cdh5.11.1+0-1.cdh5.11.1.p0.6.el6.x86_64.rpm" > impala-shell-2.8.0+cdh5.11.1+0-1.cdh5.11.1.p0.6.el6.x86_64.rpm; \


    tar xvf hadoop-2.6.0-cdh5.11.1.tar.gz; \
    tar xvf hive-1.1.0-cdh5.11.1.tar.gz; \
    tar xvf hbase-1.2.0-cdh5.11.1.tar.gz; \
    tar xvf sentry-1.5.1-cdh5.11.1.tar.gz; \
    tar xvf SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904-el6.parcel; \
    tar xvf KAFKA-2.1.1-1.2.1.1.p0.18-el6.parcel; \
    rpm2cpio impala-2.8.0+cdh5.11.1+0-1.cdh5.11.1.p0.6.el6.x86_64.rpm | cpio -idmv; \
    mv etc var usr /opt/cloudera/impala; \
    cp /opt/cloudera/impala/etc/security/limits.d/* /etc/security/limits.d/; \
    rpm2cpio impala-shell-2.8.0+cdh5.11.1+0-1.cdh5.11.1.p0.6.el6.x86_64.rpm | cpio -idmv; \
    ln -s /opt/cloudera/impala/usr/lib/impala/sbin-retail /opt/cloudera/impala/usr/lib/impala/sbin; \
    mv usr/* /opt/cloudera/impala-shell; \
    sed -ie 's@^SCRIPT_DIR=.*@SCRIPT_DIR=/opt/cloudera/impala-shell/lib/impala-shell@' /opt/cloudera/impala-shell/bin/impala-shell; \
    rm -rf usr; \

    mv hadoop-2.6.0-cdh5.11.1/bin cloudera/hadoop; \
    mv hadoop-2.6.0-cdh5.11.1/sbin cloudera/hadoop; \
    mv hadoop-2.6.0-cdh5.11.1/etc cloudera/hadoop; \
    mv hadoop-2.6.0-cdh5.11.1/lib cloudera/hadoop; \
    mv hadoop-2.6.0-cdh5.11.1/share cloudera/hadoop; \
    mv hadoop-2.6.0-cdh5.11.1/examples cloudera/hadoop; \
    mv hadoop-2.6.0-cdh5.11.1/libexec cloudera/hadoop; \

    mv hive-1.1.0-cdh5.11.1/bin cloudera/hive; \
    mv hive-1.1.0-cdh5.11.1/conf cloudera/hive; \
    mv hive-1.1.0-cdh5.11.1/auxlib cloudera/hive; \
    mv hive-1.1.0-cdh5.11.1/lib cloudera/hive; \
    mv hive-1.1.0-cdh5.11.1/scripts cloudera/hive; \
    mv hive-1.1.0-cdh5.11.1/hcatalog cloudera/hive; \
    mv hive-1.1.0-cdh5.11.1/examples cloudera/hive; \

    mv hbase-1.2.0-cdh5.11.1/lib/*.jar cloudera/hbase; \
    mv apache-sentry-1.5.1-cdh5.11.1-bin/lib/*.jar cloudera/sentry; \


    mv SPARK2-2.1.0.cloudera1-1.cdh5.7.0.p0.120904/* cloudera/spark; \
    mv KAFKA-2.1.1-1.2.1.1.p0.18/* cloudera/kafka; \

    rm -rf hadoop-2.6.0*; \
    rm -rf hive-1.1.0*; \
    rm -rf SPARK2*; \
    rm -rf KAFKA*; \
    rm -rf impala-*; \
    rm -rf hbase*; \
    rm -rf sentry*; \
    rm -rf apache-sentry*; \

    rm -r /opt/cloudera/kafka/lib/kafka/config; \
    rm -f /opt/cloudera/spark/lib/spark2/conf; \
    rm -f /opt/cloudera/spark/lib/spark2/work; \
    mkdir -p /opt/cloudera/spark/lib/spark2/conf; \
    mkdir -p /opt/cloudera/spark/lib/spark2/work; \

    chown dep -R /opt/cloudera; \
    mkdir -p /opt/hadoop_data/hdfs/namenode; \
    mkdir -p /opt/hadoop_data/hdfs/datanode; \
    chown dep -R /opt/hadoop_data; \

    echo 'export HADOOP_HOME=/opt/cloudera/hadoop' >> /etc/profile; \
    echo 'export HADOOP_INSTALL=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_YARN_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export YARN_HOME=$HADOOP_HOME' >> /etc/profile; \
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> /etc/profile; \
    echo 'export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> /etc/profile; \
    echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> /etc/profile; \
    echo 'export HIVE_HOME=/opt/cloudera/hive' >> /etc/profile; \
    echo 'export HIVE_CONF_DIR=/opt/cloudera/hive/conf' >> /etc/profile; \
    echo 'export SPARK_HOME=/opt/cloudera/spark' >> /etc/profile; \
    echo 'export SPARK_SCALA_VERSION=2.11' >> /etc/profile; \
    echo 'export KAFKA_HOME=/opt/cloudera/kafka/lib/kafka' >> /etc/profile; \
    echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$HADOOP_HOME/bin:$HIVE_HOME/bin:$KAFKA_HOME/bin:/opt/cloudera/impala:/opt/cloudera/impala-shell/bin' >> /etc/profile; \
    echo 'export LD_LIBRARY_PATH=/opt/cloudera/native/:/usr/java/jdk1.8.0_201-amd64/jre/lib/amd64/server' >> /etc/profile; \
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR="/opt/cloudera/native"' >> /etc/profile; \
    echo 'export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true -Djava.library.path=/opt/cloudera/native:/usr/java/jdk1.8.0_201-amd64/jre/lib/amd64/server"' >> /etc/profile; \
    echo 'export IMPALA_HOME=/opt/cloudera/impala/usr/lib/impala' >> /etc/profile; \
    echo 'export JAVA_HOME=/usr/java/jdk1.8.0_201-amd64' >> /etc/profile; \

    source /etc/profile; \

    #install postgres driver
	curl -v -L -b -O https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar > postgresql-9.4.1212.jar; \
	mv postgresql-9.4.1212.jar /opt/cloudera/hive/lib

COPY resources/ /opt/resources/
COPY resources/cloudera/krb_disabled/etc/hadoop/* /opt/cloudera/hadoop/etc/hadoop/
COPY resources/kerberos/krb5.conf /etc/
COPY resources/kerberos/kdc.conf /var/kerberos/krb5kdc/
COPY resources/kerberos/kadm5.acl /var/kerberos/krb5kdc/
COPY resources/cloudera/krb_disabled/etc/kafka/conf/* /etc/kafka/conf/
COPY resources/cloudera/lib/native/* /opt/cloudera/native/

RUN mv /opt/resources /home/dep/; \
    chown -R dep:hadoop /home/dep/resources; \
    echo -e "des\ndes\n" | /usr/sbin/kdb5_util create -s

USER dep
    
RUN ssh-keygen -t rsa -P "" -f $HOME/.ssh/id_rsa; \
    cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys; \
    chmod 0600 ~/.ssh/authorized_keys; \
    #prepare hadoop
    hadoop namenode -format; \
    hadoop-daemon.sh start datanode; \
    hadoop-daemon.sh start namenode; \
    yarn-daemon.sh start resourcemanager; \
    yarn-daemon.sh start nodemanager; \    
    mr-jobhistory-daemon.sh start historyserver; \
	hadoop fs -mkdir /tmp; \
	hadoop fs -mkdir -p /user/hive/warehouse; \
	hadoop fs -chmod g+w /tmp; \
    hadoop fs -chmod g+w /user/hive/warehouse; \
    hadoop fs -mkdir /user/spark; \
    hadoop fs -mkdir /user/spark/applicationHistory; \
    hadoop fs -chmod 1777 /user/spark/applicationHistory

USER root

RUN ln -s /opt/cloudera/native/libhadoop.so.1.0.0 /opt/cloudera/native/libhadoop.so; \
    ln -s /opt/cloudera/native/libnativetask.so.1.0.0 /opt/cloudera/native/libnativetask.so; \
    ln -s /opt/cloudera/native/libsnappy.so.1.1.3 /opt/cloudera/native/libsnappy.so.1; \
    ln -s /opt/cloudera/native/libsnappy.so.1.1.3 /opt/cloudera/native/libsnappy.so; \
    mkdir -p /etc/hadoop/conf; \
    mkdir -p /var/run/spark; \
    mkdir -p /var/log/spark; \
    chown -R dep:hadoop /var/run/spark; \
    chown -R dep:hadoop /var/log/spark; \
    mkdir /opt/cloudera/spark/sbin; \
    ln -s  /etc/kafka/conf /opt/cloudera/kafka/lib/kafka/config; \
    chown -R dep:hadoop /opt/cloudera; \
    cp /opt/cloudera/spark/lib/spark2/sbin/* /opt/cloudera/spark/sbin; \
    ln -s /opt/cloudera/hadoop/etc/hadoop/core-site.xml  /etc/hadoop/conf/core-site.xml; \
    ln -s /opt/cloudera/hadoop/etc/hadoop/hdfs-site.xml  /etc/hadoop/conf/hdfs-site.xml

USER dep

COPY resources/cloudera/krb_disabled/etc/spark/* /opt/cloudera/spark/conf/
COPY resources/cloudera/krb_disabled/etc/spark/* /opt/cloudera/spark/lib/spark2/conf/

COPY resources/cloudera/krb_disabled/etc/impala/conf/* /opt/cloudera/impala/etc/
COPY resources/cloudera/krb_disabled/etc/impala/impala-init.sh /opt/cloudera/impala/

RUN mkdir -p /opt/cloudera/spark/assembly/target/scala-2.10/jars; \
    mkdir -p /opt/cloudera/spark/assembly/target/scala-2.11/jars; \
 	cp /opt/cloudera/spark/lib/spark2/jars/* /opt/cloudera/spark/assembly/target/scala-2.10/jars; \
	cp /opt/cloudera/spark/lib/spark2/jars/* /opt/cloudera/spark/assembly/target/scala-2.11/jars; \
	cp /opt/cloudera/spark/lib/spark2/bin/load-spark-env.sh /opt/cloudera/spark/bin; \
	cp /opt/cloudera/spark/lib/spark2/bin/spark-class /opt/cloudera/spark/bin; \
	cp /opt/cloudera/spark/lib/spark2/bin/spark-submit /opt/cloudera/spark/bin; \
	cp /opt/cloudera/spark/lib/spark2/bin/spark-shell /opt/cloudera/spark/bin; \
	cp /opt/cloudera/spark/lib/spark2/yarn/spark-2.1.0.cloudera1-yarn-shuffle.jar /opt/cloudera/hadoop/share/hadoop/yarn
	
ENV SPARK_DIST_CLASSPATH="$HIVE_HOME/lib/*:$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"

USER root

RUN chown dep:hadoop /opt/cloudera/impala/impala-init.sh

COPY resources/cloudera/krb_disabled/etc/hive/conf/* /opt/cloudera/hive/conf/

COPY resources/cloudera/krb_disabled/etc/impala/impala /etc/default/
COPY resources/cloudera/krb_disabled/etc/impala/conf/* /etc/impala/
COPY resources/cloudera/krb_disabled/etc/impala/conf/* /etc/impala/conf/

USER root

#########################

#ARG PROVISION
#ENV PROVISION ${PROVISION}
ENV SPRING_CONFIG_LOCATION=/opt/des/jobserver/application.properties
ENV SPARK_SCALA_VERSION=2.11

COPY resources/init.sh /opt/

RUN chmod +x /opt/init.sh

ENTRYPOINT /opt/init.sh
