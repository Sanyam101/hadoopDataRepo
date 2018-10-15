#!/bin/sh

RELEASE_ID=$1
TEMP_DIR=$2

TEMP_OOZIE_HOME=$TEMP_DIR/${RELEASE_ID}/oozie
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

echo "GOOD NEWS - OOZIE WORKFLOWS and COORDINATORS are ALL VALID!!"
