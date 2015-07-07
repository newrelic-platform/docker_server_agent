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


#push the two tagged images
docker push ${rootname}/nrsysmond:${nrsysmondversion}
docker push ${rootname}/nrsysmond:latest
