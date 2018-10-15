#!/bin/sh

RELEASE_ID=${1}
ENVIRONMENT=${2}
OOZIE_HOME=${3}
COMMON_HOME=${4}
DEPLOY_MAP_REDUCE=${5}
DEPLOY_UDF=${6}
MAP_REDUCE_HOME=${7}
UDF_HOME=${8}
TEMP_DIR=${9}
HIVE2_LIB_DIR=${10}

function handle_errors {
echo "Error?? : $1 - Domain : $2"
if [[ $1 -ne 0 ]] ; then
  echo "EXITING - $2 Deploy Failed : Try again later "
  exit 1
fi
}

echo "START - HDFS COPY in ENVIRONMENT : " $ENVIRONMENT

if [ $DEPLOY_MAP_REDUCE = true ] ; then
  echo "DEPLOY_MAP_REDUCE??? : " $DEPLOY_MAP_REDUCE
  hdfs dfs -rmr $MAP_REDUCE_HOME/xml-ingest*.jar
  hdfs dfs -copyFromLocal $TEMP_DIR/${RELEASE_ID}/xml-ingest*.jar $MAP_REDUCE_HOME/
  handle_errors $? "MAP_REDUCE"
fi

if [ $DEPLOY_UDF = true ] ; then
  echo "DEPLOY_UDF??? : " $DEPLOY_UDF
  rm -f $UDF_HOME/custom-cat-udfs*.jar
  cp $TEMP_DIR/${RELEASE_ID}/custom-cat-udfs*.jar $UDF_HOME/
  #Workaround for keeping the UDF JAR name same (custom-cat-udfs-0.1.14.jar) since it is cached on the Hadoop Cluster and it requires restart of HIVE to get new JAR in the CLASSPATH
  mv $UDF_HOME/custom-cat-udfs*.jar $UDF_HOME/custom-cat-udfs-0.1.14.jar
  handle_errors $? "UDF"
fi

hdfs dfs -rmr $COMMON_HOME/*
hdfs dfs -copyFromLocal $TEMP_DIR/${RELEASE_ID}/oozie/common/* $COMMON_HOME/
handle_errors $? "COMMON"

while read domain || [ -n "$domain" ];
do
  hdfs dfs -rmr $OOZIE_HOME/workspaces/ddsw_domain_ingest/$domain/*

  hdfs dfs -copyFromLocal $TEMP_DIR/${RELEASE_ID}/oozie/$domain/* $OOZIE_HOME/workspaces/ddsw_domain_ingest/$domain/
  handle_errors $? "$domain-Code"

  echo "HDFS COPY LIB : hdfs dfs -cp -f $HIVE2_LIB_DIR/ $OOZIE_HOME/workspaces/ddsw_domain_ingest/$domain/"

  hdfs dfs -cp -f $HIVE2_LIB_DIR/ $OOZIE_HOME/workspaces/ddsw_domain_ingest/$domain/
  handle_errors $? "$domain-Lib"
  
  hdfs dfs -chmod -R 755 $OOZIE_HOME/workspaces/ddsw_domain_ingest/$domain/
  handle_errors $? "$domain-permissions"
  
done < $TEMP_DIR/scripts/data/ddsw_domains.txt

echo "END - HDFS COPY in ENVIRONMENT : " $ENVIRONMENT
