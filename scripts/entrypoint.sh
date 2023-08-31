#!/bin/bash

# check that values present for user and group id
if [ "${UID}" -eq "0" ] || [ -z "$GID" ] ; then
    echo "Add -e UID=\$(id -u) -e GID=\$(id -g) to your docker run command."
    exit 1
fi
echo "Changing UID and GID for hls4ml-user to host values."
usermod -d /tmp/home/hls4ml-user hls4ml-user
usermod -u ${UID} hls4ml-user
groupmod -g ${GID} hls4ml-user
usermod -d /home/hls4ml-user hls4ml-user

echo "Setting permissions. This can take a few minutes."
chown hls4ml-user:hls4ml-user /home/hls4ml-user
chown -R espuser:espuser /home/hls4ml-user/env
chown -R espuser:espuser /home/hls4ml-user/work

# change user
echo "Changing to hls4ml-user."
su hls4ml-user
