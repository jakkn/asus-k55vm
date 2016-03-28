#!/bin/sh
#
# Set external display and audio (if hdmi)

# Set authority - necessary because udev rule runs script as root
########### Authority ###########
USER="$(who | grep :0\) | cut -f 1 -d ' ')"
export XAUTHORITY=/home/$USER/.Xauthority
export DISPLAY=:0
########### Environment ###########
THIS_PATH=$(dirname "${BASH_SOURCE[0]}")

## List by running xrandr ##
DP="DP-1"
VGA="VGA-1"
HDMI="HDMI-1"
INTERNAL_DISPLAY="LVDS-1"

DP_STATUS="$(cat /sys/class/drm/card0-DP-1/status)"
VGA_STATUS="$(cat /sys/class/drm/card0-VGA-1/status)"
HDMI_STATUS="$(cat /sys/class/drm/card0-HDMI-A-1/status)"

EXTERNAL_DISPLAY=""
EXTERNAL_DISPLAY_STATUS="disconnected"
# Check to see if the external display is connected
if [ $DP_STATUS = connected ]; then
  EXTERNAL_DISPLAY=$DP
  EXTERNAL_DISPLAY_STATUS="connected"
fi
if [ $VGA_STATUS = connected ]; then
  EXTERNAL_DISPLAY=$VGA
  EXTERNAL_DISPLAY_STATUS="connected"
fi
if [ $HDMI_STATUS = connected ]; then
  EXTERNAL_DISPLAY=$HDMI
  EXTERNAL_DISPLAY_STATUS="connected"
fi

# Change display
if [ $EXTERNAL_DISPLAY_STATUS = "connected" ]; then
  xrandr --output $INTERNAL_DISPLAY --off --output $EXTERNAL_DISPLAY --auto
  # If HDMI, use HDMI audio output
  if [ $EXTERNAL_DISPLAY = $HDMI ]; then
    $THIS_PATH/hdmi_sound.sh
  fi
# Restore internal display
else
  xrandr --output $EXTERNAL_DISPLAY --off --output $INTERNAL_DISPLAY --auto
  # Restore audio output
    $THIS_PATH/hdmi_sound.sh
fi

exit 0