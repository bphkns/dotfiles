#!/bin/sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
  exec sudo -- "$0" "$@"
fi

PCI_DEV="${OMARCHY_INTEL_BE200_PCI_DEV:-0000:01:00.0}"
src_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
rule_src="$src_dir/80-intel-be200-disable-d3cold.rules"
rule_dst="/etc/udev/rules.d/80-intel-be200-disable-d3cold.rules"

# Remove the stronger workaround from earlier testing if it is still present.
rm -f /usr/lib/systemd/system-sleep/intel-be200-suspend-hook.sh
rm -f /etc/systemd/system-sleep/intel-be200-suspend-hook.sh

install -Dm644 "$rule_src" "$rule_dst"
udevadm control --reload

if [ -e "/sys/bus/pci/devices/$PCI_DEV" ]; then
  udevadm trigger --action=add "/sys/bus/pci/devices/$PCI_DEV" || true

  if [ -w "/sys/bus/pci/devices/$PCI_DEV/d3cold_allowed" ]; then
    printf '0' > "/sys/bus/pci/devices/$PCI_DEV/d3cold_allowed"
  fi

  printf 'Installed Intel BE200 D3cold workaround. Current d3cold_allowed: '
  cat "/sys/bus/pci/devices/$PCI_DEV/d3cold_allowed"
else
  printf 'Installed Intel BE200 D3cold workaround, but PCI device %s was not found. Reboot or check the PCI address.\n' "$PCI_DEV"
fi
