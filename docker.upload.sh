#!/usr/bin/env bash
#
# Shell script to create a Dockerfile from a template, populating certain key
# values, and to then build a Docker image. Requires that you are already
# logged in to Docker Hub.
#

rootname="newrelic"
if [ $# -ne 0 ]
  then
rootname=$1
fi

# Get the current version from download.newrelic.com without redownloading.
nrsysmondversion="$(curl -s http://download.newrelic.com/server_monitor/release/ | perl -wne 'print $1 if (/newrelic-sysmond-([0-9\\.]+)-linux/)')"

#push the two tagged images
docker push ${rootname}/nrsysmond:${nrsysmondversion}
docker push ${rootname}/nrsysmond:latest
