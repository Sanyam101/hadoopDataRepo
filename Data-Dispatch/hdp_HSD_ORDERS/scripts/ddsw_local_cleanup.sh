#!/bin/sh
#
#
#

LOCAL_TEMP_DIR=tmp/stage

echo "START - LOCAL CLEANUP in ENVIRONMENT : " $ENVIRONMENT
echo "RELEASE_ID : " $RELEASE_ID
echo "TEMP_DIR : " $TEMP_DIR
echo "LOCAL_TEMP_DIR : " $LOCAL_TEMP_DIR

rm -rf $LOCAL_TEMP_DIR/scripts/

rm -rf $LOCAL_TEMP_DIR/${RELEASE_ID}*

echo "END - LOCAL CLEANUP in ENVIRONMENT : " $ENVIRONMENT
