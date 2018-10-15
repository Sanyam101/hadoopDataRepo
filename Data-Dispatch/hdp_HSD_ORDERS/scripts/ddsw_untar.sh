RELEASE_ID=${1}
ENVIRONMENT=${2}
TEMP_DIR=${3}
TEMP_OOZIE_HOME=$TEMP_DIR/${RELEASE_ID}/oozie
echo "TEMP_OOZIE_HOME : " $TEMP_OOZIE_HOME

function handle_errors {
echo "Error?? : $1 - Domain : $2"
if [[ $1 -ne 0 ]] ; then
    echo "EXITING - $2 XML Schema Validation FAILED : FIX It And Try again "
    echo "EXITING - Injecting Properties for $2 Failed in $ENVIRONMENT - RELEASE - $RELEASE_ID : Verify Properties Files/Directory exists with right permissions!!"
  exit 1
fi
}

pwd
cd $TEMP_DIR/
pwd

echo "START UNTAR in $ENVIRONMENT - RELEASE - $RELEASE_ID"

tar -xvf $RELEASE_ID.tar

echo "END UNTAR in $ENVIRONMENT - RELEASE - $RELEASE_ID : SUCCESS" 

echo "START Injecting Properties for $ENVIRONMENT - RELEASE - $RELEASE_ID"

while read domain
do
  rm -f $TEMP_OOZIE_HOME/$domain/job.properties
  cp $TEMP_OOZIE_HOME/common/properties/$ENVIRONMENT/$domain/job.properties $TEMP_OOZIE_HOME/$domain/
  handle_errors $? "$domain"
done < $TEMP_DIR/scripts/data/ddsw_domains.txt

rm -rf $TEMP_OOZIE_HOME/common/properties/

echo "END Injecting Properties for $ENVIRONMENT - RELEASE - $RELEASE_ID : SUCCESS" 
