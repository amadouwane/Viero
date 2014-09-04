#!/bin/bash
################################################################################
#Date:08/19/2014
#Author: 
#Copyright: 
#Usage:
#Purpose: JBOSS Startup Script
################################################################################
JBOSS_PID=`pgrep -lf java | grep jboss | cut -d' ' -f1`
clear

###################
#CREATE FUNCTIONS
###################
# Drops system caches
flushMem()
{
echo ""
echo "#######################"
echo "SYNC MEMORY"
echo "#######################"
echo "Flushing memory cache to disk..."
sync; sysctl -w vm.drop_caches=3 > /dev/null 2>&1
sleep 3
}
#-------------------------------------------------------------------------------
startJboss()
{
export JBOSS_HOME=/home/JBOSS/jboss-5.1.0.GA
export JBOSS_LOG=$JBOSS_HOME/server/default/log
export JBIN=$JBOSS_HOME/bin
export JWORK=$JBOSS_HOME/server/default/work
export JTMP=$JBOSS_HOME/server/default/tmp
export JDATA=$JBOSS_HOME/server/default/data
export JIP=0.0.0.0
export NOHUP=/usr/bin/nohup

if [ $JBOSS_PID ]
then
  echo "JBoss process (pid=${JBOSS_PID}) is already up and running !"
  exit
else
  echo ""
 echo ""
  echo "#######################"
  echo "DELETING DIRECTORIES"
  echo "#######################"
  echo "Deleting '$JWORK' directory..."
  rm -rf $JWORK;sleep 3
  echo "Deleting '$JTMP' directory..."
  rm -rf $JTMP;sleep 3
  flushMem
  echo ""
  echo "#######################"
  echo "STARTING JBOSS"
  echo "#######################"
  echo "Starting Jboss..."
  $NOHUP $JBIN/run.sh -b ${JIP} > /dev/null 2>&1  &
  sleep 5
fi

#Check whether JBoss has successfully started...
JBOSS_NEW_PID=`pgrep -lf java | grep jboss | cut -d' ' -f1`
if [ $JBOSS_NEW_PID ]
then
  echo "JBoss started successfully. New PID is $JBOSS_NEW_PID."
else
  echo "JBoss was not started..."
fi
}
#-------------------------------------------------------------------------------
###################
#FUNCTION CALLS
###################
startJboss
