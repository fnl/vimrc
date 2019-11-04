#!/usr/bin/env bash
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

# actual battery level
BATT=`ioreg -c AppleDeviceManagementHIDEventService -r -l | grep -i mouse -A 20 | grep BatteryPercent | cut -d= -f2 | cut -d' ' -f2`

# defaults to warn at 15%; accepts other number as 1st argument (useful for testing)
COMPARE=${1:-15}

# crontab entry:
# */15 * * * * cd ~ && bash ~/.vim/bin/mouse-battery-check.sh

if [ -z "$BATT" ]; then
  # echo 'No mouse found.'
  exit 0
fi

if (( BATT < COMPARE )); then
  osascript -e "display notification \"Mouse battery is at ${BATT}%.\" with title \"Mouse Battery Low\""
fi
