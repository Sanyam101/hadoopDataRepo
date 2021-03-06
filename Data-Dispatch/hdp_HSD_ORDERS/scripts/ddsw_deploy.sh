#!/bin/sh

RELEASE_ID=${1}
ENVIRONMENT=${2}
DEPLOY_MAP_REDUCE=${3}
DEPLOY_UDF=${4}
WORKFLOWS=${5}
OOZIE_HOME=${6}
COMMON_HOME=${7}
MAP_REDUCE_HOME=${8}
UDF_HOME=${9}
TEMP_DIR=${10}
OOZIE_WEB_ROOT=${11}
OOZIE_USER=${12}
OOZIE_JOB_NAME_PREFIX=${13}
HIVE2_LIB_DIR=${14}

echo "START - DEPLOY in ENVIRONMENT : " $ENVIRONMENT
echo "DEPLOY - RELEASE_ID : " $RELEASE_ID
echo "DEPLOY - DEPLOY_MAP_REDUCE : " $DEPLOY_MAP_REDUCE
echo "DEPLOY - DEPLOY_UDF : " $DEPLOY_UDF
echo "DEPLOY - WORKFLOWS : " $WORKFLOWS
echo "DEPLOY - OOZIE_HOME : " $OOZIE_HOME
echo "DEPLOY - COMMON_HOME : " $COMMON_HOME
echo "DEPLOY - MAP_REDUCE_HOME : " $MAP_REDUCE_HOME
echo "DEPLOY - UDF_HOME : " $UDF_HOME
echo "DEPLOY - TEMP_DIR : " $TEMP_DIR
echo "DEPLOY - OOZIE_WEB_ROOT : " $OOZIE_WEB_ROOT
echo "DEPLOY - OOZIE_USER : " $OOZIE_USER
echo "DEPLOY - OOZIE_JOB_NAME_PREFIX : " $OOZIE_JOB_NAME_PREFIX
echo "DEPLOY - HIVE2_LIB_DIR : " $HIVE2_LIB_DIR

cd $TEMP_DIR

chmod -R 755 scripts/

#/tmp/stage/scripts/ddsw_init.sh $RELEASE_ID $ENVIRONMENT

$TEMP_DIR/scripts/ddsw_oozie_status.sh $RELEASE_ID $ENVIRONMENT $TEMP_DIR $OOZIE_WEB_ROOT $OOZIE_USER

OOZIE_RETURN_CODE=$?

echo "DEPLOY - OOZIE STATUS - Return Code : " $OOZIE_RETURN_CODE

if [[ $OOZIE_RETURN_CODE -eq 1 ]] ; then
    echo "EXITING - OOZIE STATUS UNKNOWN : Try again later "
    exit 1
elif [[ $OOZIE_RETURN_CODE -eq 2 ]] ; then
    echo "EXITING - OOZIE STILL RUNNING : Try again later "
    exit 2
fi

$TEMP_DIR/scripts/ddsw_untar.sh $RELEASE_ID $ENVIRONMENT $TEMP_DIR

if [[ $? -ne 0 ]] ; then
    echo "EXITING - UNTAR or Properties Injection FAILED : Try again later "
    exit 3
fi

$TEMP_DIR/scripts/ddsw_oozie_test.sh $RELEASE_ID $TEMP_DIR

/tmp/stage/scripts/ddsw_hdfs.sh $RELEASE_ID $ENVIRONMENT $OOZIE_HOME $COMMON_HOME $DEPLOY_MAP_REDUCE $DEPLOY_UDF $MAP_REDUCE_HOME $UDF_HOME $TEMP_DIR $HIVE2_LIB_DIR

if [[ $? -ne 0 ]] ; then
    echo "EXITING - HDFS COPY FAILED : Try again later "
    exit 4
fi

$TEMP_DIR/scripts/ddsw_remote_cleanup.sh $RELEASE_ID $ENVIRONMENT $TEMP_DIR

echo "END - DEPLOY in ENVIRONMENT : " $ENVIRONMENT " - SUCCESS"

