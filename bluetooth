#!/bin/bash

connected_devices=$(mktemp)
previously_connected_devices=$(mktemp)

bluetoothctl devices | while read -r line; do
    MAC=$(echo "$line" | awk '{print $2}')
    device_name=$(echo "$line" | cut -d ' ' -f3-)
    device_name=${device_name// /_}
    if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
        echo "$device_name|$MAC" >> "$connected_devices"
    fi
done

bluetoothctl paired-devices | while read -r line; do
    MAC=$(echo "$line" | awk '{print $2}')
    device_name=$(echo "$line" | cut -d ' ' -f3-)
    device_name=${device_name// /_}
    if bluetoothctl info "$MAC" | grep -q "Connected: no"; then
        echo "$device_name|$MAC" >> "$previously_connected_devices"
    fi
done

device_list=""

while read -r line; do
    device_list="$device_list TRUE $line "
done < "$connected_devices"

while read -r line; do
    device_list="$device_list FALSE $line "
done < "$previously_connected_devices"

selected_devices=$(zenity --list --title="Bluetooth Devices" --checklist \
  --column="Select" --column="Device Info (Name|MAC)" \
  --width=800 --height=600 \
  $device_list)


mac_addresses=()
if [ -n "$selected_devices" ]; then
    IFS='|' read -ra devices <<< "$selected_devices"
    for ((i=1; i<${#devices[@]}; i+=2)); do
        mac_addresses+=("${devices[i]}")
    done
else
    echo "No devices selected."
    exit 1
fi



bluetoothctl power off
sleep 1
bluetoothctl power on
sleep 2
#if you have a mouse and its not connecting, sometimes you need to press 'left click' in order to initiate the connection.
for mac in "${mac_addresses[@]}"; do
  [ -n "$mac" ] && bluetoothctl connect "$mac"
done

sleep 2
# Restart Equalizer-------------------------------------
#pkill <equalizername>
#nohup <equalizerexec> > /dev/null 2>&1 & disown
# Restart Equalizer-------------------------------------

rm "$connected_devices" "$previously_connected_devices"
