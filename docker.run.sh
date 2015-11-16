#!/bin/sh
# Shell script to run the New Relic Linux Server Monitor (nrsysmond) inside a
# Docker container. This is designed to use the public nrsysmond image which
# uses environment variables for all its configuration. The script will check
# to ensure that the vital variables are in fact set before running Docker.
#
# If you are using CoreOS and fleetctl there is a service template file in the
# same directory that you found this file, that can be edited and used to run
# nrsysmond on all the hosts in your fleet.

if [ -z "${NRSYSMOND_license_key}" ]; then 
  cat <<EOF
Error: the environment variable NRSYSMOND_license_key is not set. This is
       required in order to run nrsysmond inside a Docker container. Please
       run the following commands before attempting to run this script again:

       NRSYSMOND_license_key="YOUR_REAL_LICENSE_KEY"
       export NRSYSMOND_license_key
EOF
  exit 1
fi

sockarg=
cparg=
sysarg=
cgarg=

if [ -e /var/run/docker.sock ]; then
  sockarg="-v /var/run/docker.sock:/var/run/docker.sock"
elif [ -n "${DOCKER_HOST}" ]; then
  sockarg="-e DOCKER_HOST='${DOCKER_HOST}'"
fi

if [ -n "${DOCKER_CERT_PATH}" ]; then
  cparg="-e DOCKER_CERT_PATH='${DOCKER_CERT_PATH}' -v ${DOCKER_CERT_PATH}:${DOCKER_CERT_PATH}"
fi

if [ -e /sys ]; then
  sysarg="-v /sys:/host/sys"
fi

if [ -e /cgroup ]; then
  cgarg="-v /cgroup:/host/cgroup"
fi

envargs=`/usr/bin/env | grep ^NRSYSMOND_ | sed -e 's/^/-e /'`

#
# --privileged is recommended for system monitoring type tools. There is some
# annecdotal evidence that LSM will run without it but we do not recommend it.
#
# --net=host is used to ensure that LSM can contact the outside world and that
# it gets the correct host name and IP address, which can have an impact on
# correct reporting and billing.
#
/usr/bin/env docker run --pid=host -d ${envargs} -v /proc:/host/proc -v /dev:/host/dev ${sysarg} \
    ${cgarg} ${sockarg} ${cparg} --privileged=true --net=host \
    -E NRSYSMOND_host_root=/host \
    newrelic/nrsysmond:latest
