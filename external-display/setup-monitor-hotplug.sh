#!/bin/bash
#
# udev rule can get triggered before the monitor has been added to x renderers.
# Use systemd service to get proper behavior.
# Reference: https://bbs.archlinux.org/viewtopic.php?id=170294

HOTPLUG_SCRIPT="$(pwd)/monitor_hotplug.sh"

# Setup systemd service
SYSTEMD_SERVICE="[Unit]\nDescription=Monitor hotplug\n\n[Service]\nType=simple\nRemainAfterExit=no\nUser=$USER\nExecStart=$HOTPLUG_SCRIPT\n\n[Install]\nWantedBy=multi-user.target\n"
SERVICE_FILE="monitor_hotplug.service"
printf "$SYSTEMD_SERVICE" | sudo tee /etc/systemd/system/$SERVICE_FILE > /dev/null

# Setup udev rule
UDEV_RULE="KERNEL==\"card0\", SUBSYSTEM==\"drm\", ENV{DISPLAY}=\":0\", ENV{XAUTHORITY}=\"/home/$USER/.Xauthority\", RUN+=\"/usr/bin/systemctl start $SERVICE_FILE\""
echo "$UDEV_RULE" | sudo tee /etc/udev/rules.d/95-monitor-hotplug.rules  > /dev/null
sudo udevadm control --reload