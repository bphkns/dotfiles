#!/bin/sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
  exec sudo -- "$0" "$@"
fi

rm -f /etc/udev/rules.d/80-intel-be200-disable-d3cold.rules

# Also remove the stronger workaround from earlier testing if it is present.
rm -f /usr/lib/systemd/system-sleep/intel-be200-suspend-hook.sh
rm -f /etc/systemd/system-sleep/intel-be200-suspend-hook.sh

udevadm control --reload

printf 'Removed Intel BE200 D3cold workaround. Reboot to restore default PCI power behavior.\n'
