#!/bin/sh

RELEASE_ID=${1}
ENVIRONMENT=${2}
TEMP_DIR=${3}
OOZIE_WEB_ROOT=${4}
OOZIE_USER=${5}

echo "OOZIE STATUS - RELEASE ID : " $RELEASE_ID
echo "OOZIE STATUS - ENVIRONMENT : " $ENVIRONMENT
echo "OOZIE STATUS - TEMP_DIR : " $TEMP_DIR
echo "OOZIE STATUS - OOZIE_WEB_ROOT : " $OOZIE_WEB_ROOT
echo "OOZIE STATUS - OOZIE_USER : " $OOZIE_USER

pwd
cd $TEMP_DIR/
pwd

OOZIE_STATUS=IDLE

echo "OOZIE STATUS Command : oozie jobs -oozie ${OOZIE_WEB_ROOT} -jobtype wf -filter user=${OOZIE_USER}\;status=RUNNING | grep \"ddsw -> ${ENVIRONMENT}\" > ${RELEASE_ID}-oozie_status.log"

oozie jobs -oozie ${OOZIE_WEB_ROOT} -jobtype wf -filter user=${OOZIE_USER}\;status=RUNNING | grep "ddsw -> ${ENVIRONMENT}" > ${RELEASE_ID}-oozie_status.log
#oozie jobs -oozie http://hdtedge1.lrd.cat.com:11000/oozie/ -jobtype wf -filter user=hdddwa90\;status=RUNNING | grep "ddsw -> ${ENVIRONMENT}" > ${RELEASE_ID}-oozie_status.log

OOZIE_RETURN_CODE=$?

echo "OOZIE STATUS - Return Code : " $OOZIE_RETURN_CODE

LINE_COUNT=$(wc -l < ${RELEASE_ID}-oozie_status.log)
echo "RUNNING JOB COUNT : " $LINE_COUNT

if ((LINE_COUNT > 0)); then
  OOZIE_STATUS=BUSY
  echo "EXITING - OOZIE_STATUS : " $OOZIE_STATUS
  exit 2
fi

echo "GOOD NEWS - OOZIE_STATUS : " $OOZIE_STATUS

