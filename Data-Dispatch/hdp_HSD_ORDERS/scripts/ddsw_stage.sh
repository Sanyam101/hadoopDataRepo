#!/bin/sh
#
#
#

LOCAL_TEMP_DIR=tmp/stage

echo "START - STAGE in ENVIRONMENT : " $ENVIRONMENT
echo "RELEASE_ID : " $RELEASE_ID
echo "TEMP_DIR : " $TEMP_DIR
echo "LOCAL_TEMP_DIR : " $LOCAL_TEMP_DIR
echo "WORKSPACE : " $WORKSPACE
echo "DEPLOY_MAP_REDUCE : " $DEPLOY_MAP_REDUCE
echo "DEPLOY_UDF : " $DEPLOY_UDF
echo "WORKFLOWS : " $WORKFLOWS
echo "BUILD_NUMBER : " $BUILD_NUMBER
echo "GIT_TAG_NAME : " $GIT_TAG_NAME

NEXUS_RELEASE_REPO=http://arlpscsp01.ecorp.cat.com:8081/nexus/content/repositories/releases/com/cat/ddsw/ddsw

echo "NEXUS_RELEASE_REPO : " $NEXUS_RELEASE_REPO

rm -rf $LOCAL_TEMP_DIR/
mkdir -p $LOCAL_TEMP_DIR/
cd $LOCAL_TEMP_DIR/

echo "Getting RELEASE TAR from NEXUS : $NEXUS_RELEASE_REPO/${RELEASE_ID:5}/$RELEASE_ID.tar"

wget "$NEXUS_RELEASE_REPO/${RELEASE_ID:5}/$RELEASE_ID.tar"

cp -R "$WORKSPACE/jenkins/scripts" ./

chmod -R 755 $LOCAL_TEMP_DIR/

echo "END - STAGE in ENVIRONMENT : " $ENVIRONMENT " - SUCCESS"

