#!/usr/bin/env bash
# Verify this machine's September 17 backport, including the actually loaded code.
set -euo pipefail

if [[ ! -r /sys/class/dmi/id/product_name ]] ||
   [[ $(< /sys/class/dmi/id/product_name) != 'ProArt P16 H7606WW_H7606WW' ]]; then
  printf 'SKIP: this repair is only for the ProArt P16 H7606WW. Nothing changed.\n'
  exit 77
fi

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
kernel=7.2.5-3-omarchy

if [[ $(uname -r) != "$kernel" ]]; then
  printf 'This check targets %s. Boot linux-omarchy, or revalidate after a kernel update.\n' "$kernel" >&2
  exit 1
fi

cmp "$repo/nvidia-610.57.04.conf" /etc/dkms/nvidia-610.57.04.conf
cmp "$repo/nvidia-difr-suspend-resume.patch" /etc/dkms/nvidia/patches/nvidia-difr-suspend-resume.patch
module="/usr/lib/modules/$kernel/updates/dkms/nvidia-modeset.ko.zst"
printf '%s  %s\n' a172b9cd18b36db97d854c781e8c3aa83ff0202efb4eac957a81a0542b8c1aa8 "$module" | sha256sum --check

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
zstd -dc -- "$module" > "$tmp/nvidia-modeset.ko"
objcopy --dump-section ".note.gnu.build-id=$tmp/installed.note" "$tmp/nvidia-modeset.ko"

# srcversion is unchanged by this OS-agnostic NVIDIA source patch; compare ELF
# build-ID notes instead of falsely treating the version string as proof.
if ! cmp -s "$tmp/installed.note" /sys/module/nvidia_modeset/notes/.note.gnu.build-id; then
  printf 'PENDING: patched driver is installed, but the old driver is still loaded. Reboot into linux-omarchy.\n' >&2
  exit 2
fi

printf 'PASS: the verified patched NVIDIA driver is loaded.\n'
printf 'Suspend/resume and normal-use stability still need hardware testing; see nvidia-difr-rca.md.\n'
