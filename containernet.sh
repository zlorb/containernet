#!/bin/bash

# Set the following to your 'pfnet' folder
pfnet=""
if [ -z "$pfnet" ]
then
    pfnet=`pwd`
    echo -e "\n\n*** 'pfenet' location is not configured inside this script \n*** -- using local folder as fallback.\n"
fi

# Check for required environment usersettingsecho "*** Checking environment"
if [ -z "$VNEX_PROJECT_HOME" ]
then
    echo -e "\n\n*** 'VNEX_PROJECT_HOME' environment variable is not set.\n*** -- existing.\n"
    exit 1;
fi
if [ -z "$DOCKER_PROJECT_HOME" ]
then
    echo -e "\n\n*** 'DOCKER_PROJECT_HOME' environment variable is not set.\n*** -- existing...\n"
    exit 1;
fi


echo Docker pruning
docker image prune -f
docker container prune -f

echo Restarting XServer
kill `ps xaw | grep XQuartz | grep -v grep | awk '{print $1}'` &> /dev/null
sleep 3
# open -a XQuartz &
xhost - &> /dev/null

echo Current configuration:
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $ip &> /dev/null
# xhost +
display_number=`ps -ef | grep "Xquartz :\d" | grep -v xinit | awk '{ print $9; }'`
echo $ip $display_number

echo Starting containernet
# docker ... xterm  or  /bin/bash
(sleep 10 && open http://127.0.0.1:8888/notebooks/test.ipynb) &
docker run --name containernet -it --rm --privileged -p 8888:8888 --pid='host' -e DISPLAY=$ip$display_number -e VNEX_PROJECT_HOME=$VNEX_PROJECT_HOME -e DOCKER_PROJECT_HOME=$DOCKER_PROJECT_HOME -e pfnet=$pfnet -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/.X11-unix:/tmp/.X11-unix -v $pfnet:/mnt containernet jupyter.sh examples/test.ipynb
