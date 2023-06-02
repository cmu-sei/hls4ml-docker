#!/bin/bash

# check that values present for user id
if [ -z "${LOCAL_UID}" ]; then
    echo "Add -e LOCAL_UID=\$(id -u) to your docker run command."
    exit 1
fi
echo "Changing UID for hls4ml-user to host UID. This can take several minutes."
usermod -u ${LOCAL_UID} hls4ml-user
echo "Setting permissions."
chown -R hls4ml-user:hls4ml-user /home/hls4ml-user

# change user
echo "Changing to hls4ml-user."
su hls4ml-user
