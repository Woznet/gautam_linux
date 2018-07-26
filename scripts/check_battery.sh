#!/bin/bash

exec 1>/var/tmp/check_battery.log 2>&1

while :; do
    NOW=$(date)
    BATTERY_STATE=$(upower -i $(upower -e | grep 'BAT') | grep state | awk '{print $2}')
    BATTERY_PERCENTAGE=$(upower -i $(upower -e | grep 'BAT') | grep percentage | awk '{print $2}' | cut -d'%' -f1)

    if [ "${BATTERY_STATE}" = "discharging" ] && [ "${BATTERY_PERCENTAGE}" -lt 20 ]
    then
        echo "[${NOW}] sending message to plug-in charger"
        xmessage "You should probably plug-in the charger now!"
    # state becomes 'fully-charged' when the battery is full
    elif [ "${BATTERY_STATE}" = "charging" ] && [ "${BATTERY_PERCENTAGE}" -gt 95 ]
    then
        echo "[${NOW}] sending message to unplug charger"
        xmessage "Get ready to check state FULL"
    else
        echo "[${NOW}] Nothing to do, battery ${BATTERY_STATE}, level ${BATTERY_PERCENTAGE}%"
    fi

    # Sleep for 10 minutes
    sleep 600
done
