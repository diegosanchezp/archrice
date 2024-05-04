#!/bin/bash

# Path to the temporary file where the previous battery level is stored
previous_level_file="/tmp/battery_level.txt"

# Get the current battery level
current_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')

# Check if the previous level file exists
if [[ ! -f $previous_level_file ]]; then
  # This is the first run, so save the current level
  echo "$current_level" > $previous_level_file
  exit 0
fi

# Read the previous battery level from the file
previous_level=$(cat $previous_level_file)

# Calculate the difference between the current and previous levels
level_difference=$((previous_level - current_level))

# Check if the difference is at least 10%
if [[ $level_difference -ge 10 ]]; then
  # Send a notification
  notify-send "Battery Low" "Your battery level has dropped by 10% to $current_level%. Please connect your charger to avoid power loss."
  # Update the previous level file
  echo "$current_level" > $previous_level_file
fi
