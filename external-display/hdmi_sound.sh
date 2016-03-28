#! /bin/bash

HDMI_STATUS=$(cat /sys/class/drm/card0-HDMI-A-1/status)

if [[ $HDMI_STATUS = "connected" ]]; then
    sed -i s/hw:0,0/hw:0,3/g ~/.asoundrc
else
    sed -i s/hw:0,3/hw:0,0/g ~/.asoundrc
fi
