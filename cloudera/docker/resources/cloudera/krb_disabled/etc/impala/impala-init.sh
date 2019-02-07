#!/usr/bin/env bash

source /etc/default/impala
export JAVA_HOME IMPALA_CATALOG_SERVICE_HOST IMPALA_STATE_STORE_HOST IMPALA_STATE_STORE_PORT IMPALA_BACKEND_PORT IMPALA_LOG_DIR IMPALA_CATALOG_ARGS IMPALA_STATE_STORE_ARGS IMPALA_SERVER_ARGS ENABLE_CORE_DUMPS LIBHDFS_OPTS IMPALA_BIN HIVE_HOME IMPALA_HOME IMPALA_CONF_DIR HADOOP_CONF_DIR HIVE_CONF_DIR

export LD_LIBRARY_PATH="${JAVA_HOME}"/jre/lib/amd64/server:"${JAVA_HOME}"/jre/lib/amd64:/opt/cloudera/native
export LD_LIBRARY_PATH="${IMPALA_HOME}/lib:${IMPALA_BIN}:${LD_LIBRARY_PATH}"

export CLASSPATH_IMPALA=$(JARS=("$IMPALA_HOME"/lib/*.jar); IFS=:; echo "${JARS[*]}")
export CLASSPATH_HADOOP1=$(JARS=("/opt/cloudera/hadoop/share/hadoop/common/lib"/*.jar); IFS=:; echo "${JARS[*]}")
export CLASSPATH_HADOOP2=$(JARS=("/opt/cloudera/hadoop/share/hadoop/hdfs/lib"/*.jar); IFS=:; echo "${JARS[*]}")
export CLASSPATH_HIVE=$(JARS=("/opt/cloudera/hive/lib"/*.jar); IFS=:; echo "${JARS[*]}")
export CLASSPATH_HBASE=$(JARS=("/opt/cloudera/hbase"/*.jar); IFS=:; echo "${JARS[*]}")
export CLASSPATH_SENTRY=$(JARS=("/opt/cloudera/sentry"/*.jar); IFS=:; echo "${JARS[*]}")
export CLASSPATH=/etc/impala/conf:$CLASSPATH_IMPALA:$CLASSPATH_HADOOP1:$CLASSPATH_HADOOP2:$CLASSPATH_HBASE:$CLASSPATH_HIVE:$CLASSPATH_SENTRY


${IMPALA_BIN}/statestored ${IMPALA_STATE_STORE_ARGS} &

${IMPALA_BIN}/catalogd ${IMPALA_CATALOG_ARGS} &

${IMPALA_BIN}/impalad ${IMPALA_SERVER_ARGS} &