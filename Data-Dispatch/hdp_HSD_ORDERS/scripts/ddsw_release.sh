#!/bin/sh

echo "START - RELEASE on : " $GIT_BRANCH

echo "GIT_BRANCH : " $GIT_BRANCH
echo "NEXT_RELEASE_ID : " $NEXT_RELEASE_ID
echo "TARGET_DOMAIN : " $TARGET_DOMAIN
echo "BUILD_NUMBER : " $BUILD_NUMBER
echo "GIT_TAG_NAME : " $GIT_TAG_NAME

git config --global credential.helper store
git config --global credential.https://arlgitgisp01.ecorp.cat.com.username patelh3

git checkout $GIT_BRANCH 

git pull --rebase

./gradlew currentVersion 

if [[ ! -z $NEXT_RELEASE_ID ]] ; then
  ./gradlew clean markNextVersion -Prelease.disableChecks -Prelease.pushTagsOnly -Prelease.nextVersion=$NEXT_RELEASE_ID -Prelease.customUsername=$GIT_USER -Prelease.customPassword=$GIT_PASSWORD  --stacktrace
else
./gradlew clean release -Prelease.disableChecks -Prelease.pushTagsOnly -Prelease.customUsername=$GIT_USER -Prelease.customPassword=$GIT_PASSWORD --stacktrace
fi

if [[ $? -ne 0 ]] ; then
    echo "EXITING - Releasing new Version FAILED : Try again later "
    exit 1
fi

./gradlew currentVersion 

./gradlew build distTar upload -PtargetDomain=$TARGET_DOMAIN --stacktrace

if [[ $? -ne 0 ]] ; then
    echo "EXITING - BUILD, TAR or UPLOAD FAILED : Try again later "
    exit 2
fi

#git credential-cache exit

echo "END - RELEASE on $GIT_BRANCH - SUCCESS"
