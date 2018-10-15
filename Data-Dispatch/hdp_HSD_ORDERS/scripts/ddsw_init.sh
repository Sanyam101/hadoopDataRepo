echo "INIT : " $2 

echo "RELEASE_ID : " $1

cd /tmp/stage/

pwd
RELEASE_HOME=$1
SCRIPT_DIR=scripts

if [ -d "$RELEASE_HOME" ]; then
   rm -r $RELEASE_HOME/
   echo "REMOVED OLD : " $RELEASE_HOME
fi

mkdir $RELEASE_HOME/

pwd
pwd
mv $SCRIPT_DIR/ $RELEASE_HOME/

chmod 755 $RELEASE_HOME/$SCRIPT_DIR/*
