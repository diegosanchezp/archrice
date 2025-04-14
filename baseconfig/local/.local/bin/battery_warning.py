#!/usr/bin/env python3

import argparse
import logging
import tempfile
import dbus
from pathlib import Path
import sys
from typing import Any


# See The "State" property on https://upower.freedesktop.org/docs/Device.html#Device.properties
battery_state_names = {
    0: "Unknown",
    1: "Charging",
    2: "Discharging",
    3: "Empty",
    4: "Fully charged",
    5: "Pending charge",
    6: "Pending discharge",
}

UPOWER_DEVICE_INTERFACE = "org.freedesktop.UPower.Device"
# Configure logging
logging.basicConfig(level=logging.INFO, format='%(levelname)s - %(message)s')

def get_battery_properties():
    """
    See https://upower.freedesktop.org/docs/Device.html
    """

    try:
        # Connect to the system bus
        bus = dbus.SystemBus()

        # Access the UPower service and battery device
        # Note: The device path might vary (e.g., BAT1). Consider making this configurable or dynamic if needed.
        battery_object = bus.get_object('org.freedesktop.UPower', '/org/freedesktop/UPower/devices/battery_BAT0')

        # Interface for accessing properties
        battery_properties = dbus.Interface(battery_object, 'org.freedesktop.DBus.Properties')
        return battery_properties

    except dbus.exceptions.DBusException as e:
        logging.error(f"Failed to get battery properties interface via DBus: {e}")
        # Consider exiting or returning a specific error code/value
        sys.exit(1) # Exit if we can't get the battery properties interface

    except Exception as e:
        logging.error(f"An unexpected error occurred in get_battery_properties: {e}")
        sys.exit(1)


def get_battery_state() -> dbus.UInt32:
    """
    Retrieves the current battery state using DBus and UPower.
    """

    battery_properties = get_battery_properties()

    # Retrieve the battery state
    battery_state: dbus.UInt32 = battery_properties.Get(UPOWER_DEVICE_INTERFACE, "State")
    return battery_state

def get_battery_percentage():
    """Retrieves the current battery percentage using DBus and UPower."""

    battery_properties = get_battery_properties()

    # Retrieve the battery percentage
    percentage = battery_properties.Get(UPOWER_DEVICE_INTERFACE, "Percentage")

    # Return the percentage as an integer
    return int(percentage)


def read_previous_level(filepath: Path) -> int | None:
    """Reads the previously recorded battery level from a file."""
    if not filepath.exists():
        logging.info(f"Previous level file not found: {filepath}. First run?")
        return None
    try:
        level_str = filepath.read_text().strip()
        if not level_str:
             logging.warning(f"Previous level file is empty: {filepath}")
             return None
        return int(level_str)
    except FileNotFoundError:
        logging.info(f"Previous level file not found: {filepath}. First run?")
        return None
    except ValueError:
        logging.warning(f"Invalid content in previous level file: {filepath}. Ignoring.")
        return None
    except Exception as e:
        logging.error(f"Error reading previous level file {filepath}: {e}")
        return None # Treat errors as if the file didn't exist or was invalid


def write_current_level(filepath: Path, level: int) -> None:
    """Writes the current battery level to the specified file."""
    try:
        filepath.write_text(str(level))
        logging.debug(f"Successfully wrote current level {level} to {filepath}")
    except Exception as e:
        logging.error(f"Failed to write current level to {filepath}: {e}")


def send_notification(
    app_name: str,
    replaces_id: int,
    app_icon: str,
    summary: str,
    body: str,
    actions: list[str],
    hints: dict[str, Any],
    expire_timeout: int,
    bus: dbus.SessionBus | None = None, 
):
    """Sends a desktop notification
    
    Args:
        bus: D-Bus session bus connection
        app_name: Name of the application sending the notification
        replaces_id: Replaces existing notification with this ID (0 means create new)
        app_icon: Icon name or path (empty string for no icon)
        summary: Summary/title of the notification
        body: Body text of the notification
        actions: List of actions (empty list for no actions)
        hints: Dictionary of hints (empty dict for no hints)
        expire_timeout: Time in milliseconds before notification expires
    """

    # Get dbus session if none is passed
    if bus is None:
        bus = dbus.SessionBus()

    # Get the Notifications object
    notifications = bus.get_object('org.freedesktop.Notifications', '/org/freedesktop/Notifications')

    # Create an interface to interact with the Notifications object
    interface = dbus.Interface(notifications, 'org.freedesktop.Notifications')

    # Send a notification
    notification_id = interface.Notify(
        app_name,
        replaces_id,
        app_icon,
        summary,
        body,
        actions,
        hints,
        expire_timeout
    )

def send_warning_notification(level: int, drop: int):
    """Sends a desktop notification about the battery level drop."""
    summary = "Battery Low"
    body = f"Your battery level has dropped by at least {drop}% to {level}%. Please connect your charger."
    
    try:
        send_notification(
            app_name="Battery Warning",
            replaces_id=0,  # Create new notification
            app_icon="battery-low",  # Standard battery icon
            summary=summary,
            body=body,
            actions=[],  # No actions needed
            hints={
                "urgency": dbus.Byte(2)  # 2 = Critical urgency
            },
            expire_timeout=600000  # 10 minutes in milliseconds
        )
        logging.info(f"Sent notification for battery level {level}%")
    except Exception as e:
        logging.error(f"An unexpected error occurred during notification: {e}")


# to test, disconnect your battery cable, wait level to drop by 1%, then execute like this: battery_warning.py --threshold 1
def main():
    """Main function to check battery level and send notifications."""
    parser = argparse.ArgumentParser(description="Monitor battery level drops and send notifications.")
    parser.add_argument(
        "--threshold",
        type=int,
        default=10,
        help="The percentage drop required to trigger a notification (default: 10)."
    )
    parser.add_argument(
        "--state-file",
        type=str,
        default="battery_level.txt",
        help="Name of the file used to store the last recorded battery level within the system's temp directory (default: battery_level.txt)."
    )
    args = parser.parse_args()

    temp_dir = Path(tempfile.gettempdir())
    previous_level_file = temp_dir / args.state_file
    logging.info(f"Using state file: {previous_level_file}")

    battery_state = get_battery_state()

    # Successfully Exit if the battery is 1: Charging or 4: Fully charged
    if battery_state in [1, 4]:
        logging.info(f"Exit program early, battery state is {battery_state_names[battery_state]}")
        sys.exit(0)

    current_level = get_battery_percentage()
    logging.info(f"Current battery level: {current_level}%")

    previous_level = read_previous_level(previous_level_file)

    if previous_level is not None:
        logging.info(f"Previous battery level: {previous_level}%")
        level_difference = previous_level - current_level

        # Only notify if the level has actually decreased by the threshold or more
        if level_difference >= args.threshold:
            logging.info(f"Battery level dropped by {level_difference}% (>= threshold {args.threshold}%).")
            send_warning_notification(current_level, args.threshold)
            # Update the state file only after a significant drop notification
            write_current_level(previous_level_file, current_level)
        elif current_level != previous_level:
             # Update the file if the level changed, but not enough to notify,
             # ensuring the 'previous_level' is always the last *recorded* level.
             logging.debug(f"Battery level changed to {current_level}%, but drop ({level_difference}%) is less than threshold ({args.threshold}%). Updating state file.")
             write_current_level(previous_level_file, current_level)
        else:
            logging.debug("Battery level unchanged.")
    else:
        # First run or previous state was invalid/unreadable
        logging.info("No valid previous level found. Saving current level.")
        write_current_level(previous_level_file, current_level)

if __name__ == "__main__":
    main()
