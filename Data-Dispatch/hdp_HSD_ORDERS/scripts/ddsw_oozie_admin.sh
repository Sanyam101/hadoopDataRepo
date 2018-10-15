#!/bin/sh
#  adding comment  
RELEASE_ID=$1
TEMP_DIR=$2
OOZIE_WEB_ROOT=$3

TEMP_OOZIE_HOME=$TEMP_DIR/${RELEASE_ID}/${RELEASE_ID}/oozie
echo "TEMP_OOZIE_HOME : " $TEMP_OOZIE_HOME

pwd
cd $TEMP_DIR/
pwd

OOZIE_STATUS=IDLE

function handle_errors {
echo "Error?? : $1 - Domain : $2"
if [[ $1 -ne 0 ]] ; then
    echo "EXITING - $2 XML Schema Validation FAILED : FIX It And Try again "
  exit 1
fi
}

while read domain
do
  oozie validate $TEMP_OOZIE_HOME/$domain/workflow.xml
  handle_errors $? "$domain - WORKFLOW"

  oozie validate $TEMP_OOZIE_HOME/$domain/coordinator.xml
  handle_errors $? "$domain - COORDINATOR"
done < $TEMP_DIR/scripts/data/ddsw_domains.txt

oozie admin -oozie ${OOZIE_WEB_ROOT} -status > $RELEASE_ID/oozie_status.log

if [[ $? -ne 0 ]] ; then
    echo "OOZIE System STATUS Unknown : Trying to bring Oozie back in Business!!" 
    oozie admin -oozie ${OOZIE_WEB_ROOT} -systemmode NORMAL
    if [[ $? -ne 0 ]] ; then
        echo "OOZIE System can't be Restored : Try Manually!!"
        exit 12
    else
        oozie admin -oozie ${OOZIE_WEB_ROOT} -status > $RELEASE_ID/oozie_status.log
        if [[ $? -ne 0 ]] ; then
            echo "OOZIE System can't be Restored : Try Manually!!"
            exit 13
        fi
    fi
fi

LINE_COUNT=$(wc -l < $RELEASE_ID/oozie_status.log)
echo "RUNNING JOB COUNT : " $LINE_COUNT

if ((LINE_COUNT > 0)); then
  OOZIE_STATUS=BUSY
  echo "EXITING - OOZIE_STATUS : " $OOZIE_STATUS
  exit 13
fi

echo "GOOD NEWS - OOZIE is UP and RUNNING : "

