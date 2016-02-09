# docker_server_agent [![image](https://badge.imagelayers.io/newrelic/nrsysmond.svg)](https://imagelayers.io/?images=newrelic%2Fnrsysmond:latest)

This repo includes the requisite Dockerfile and associated scripts to run the New Relic Servers for Linux agent inside of a container.

*Please note that this is an early beta and has several known issues*

##Building custom image##

The Dockerfile used to generate the [nrsysmond image](https://registry.hub.docker.com/u/newrelic/nrsysmond/)  is provided, and the script file docker.build.sh can be used to build a new image. A custom-built image may require changes (e.g. image names)in docker.run.sh, docker.upload.sh and docker.service.

##Running with fleetctl##

If you use fleetctl to manage a number of CoreOS nodes, you can use the sample service file docker.service to setup monitoring on multiple CoreOS machines. Thefile will need to be edited to insert your New Relic license key.

For more information on how to set up and run a fleetctl service , please refer to the CoreOS cluster management [documentation] (https://coreos.com/using-coreos/clustering/).



# Using environment variables #
The -E option for nrsysmond tells LSM to look for all of its configuration information in the environment, rather than in a config file. If you use the -E flag, then no config file is obeyed even if you specify one on the command line. To use the environment variables, simply ensure they are set before running nrsysmond. You can pass environment variables to a Docker container using the docker run command's -e flag.

The [New Relic Linux Server configuration page] (https://docs.newrelic.com/docs/servers/new-relic-servers-linux/installation-configuration/configuring-servers-linux) lists all the other settings for nrsysmond.

To create an environment variable for a setting, prepend NRSYSMOND_ to its name. For example,

```sh
loglevel=debug
```
translates to

```sh
-e NRSYSMOND_loglevel=debug
```

# Interested in providing feedback #
Please share your experiences with us via the [New Relic Forums](https://discuss.newrelic.com/c/server-monitoring/docker)
