# ProArt P16 freezes: NVIDIA DIFR suspend/resume backport

Date: 2026-09-17. **Fix installed; reboot and hardware validation pending.**

## Root cause and confidence

The retained September 8 kernel trace confirms an NVIDIA display-driver
livelock, not just a stuck application:

```text
Hyprland: state D, blocked for more than 1228 seconds
  nvkms_ioctl_from_kapi_try_pmlock
  ApplyModeSetConfig
  nv_drm_atomic_apply_modeset_config

nvidia-modeset/: state R, holding the semaphore Hyprland needs
  nvWriteGpEntry
  nvPushKickoff
  PrefetchHelperSurfaceEvo
  nvDIFRPrefetchSurfaces
  DifrPrefetchEventDeferredWork
```

DIFR (Display Idle Frame Refresh) saves power by scanning frames from GPU cache.
In NVIDIA 610.57.04, its prefetch/copy channel is not torn down across suspend.
After resume, failed copies can leave the small submission ring exhausted.
`nvWriteGpEntry()` then waits indefinitely for GPU progress while holding locks
needed by display operations. Hyprland blocks behind it and the display stops
updating, although other parts of the machine can remain alive.

This matches [NVIDIA issue #1289](https://github.com/NVIDIA/open-gpu-kernel-modules/issues/1289)
and the [upstream investigation and release confirmation](https://github.com/NVIDIA/open-gpu-kernel-modules/pull/1286).
NVIDIA's maintainer identifies released fixes in **595.99.02** and **615.71.09**:
free DIFR state before suspend and allocate fresh state after resume.

### Yesterday's incidents (September 16, IST)

- **13:23–15:59, linux-omarchy 7.2.5-3:** eight suspend/resume cycles;
  final resume 15:58:02, journal ends 15:59:14, next boot 16:00:32.
- **16:00–20:55, linux 7.1.9:** ten suspend/resume cycles;
  final resume 20:53:30, journal ends 20:55:14, next boot 20:57:56.
- Both next boots report an unclean journal; neither preceding session has a
  normal shutdown sequence. Both used NVIDIA **610.57.04**.

Those timings strongly fit the confirmed NVIDIA failure family. **Neither
recent incident retained a definitive deadlock trace**, so attributing both to
this exact bug remains a strong hypothesis, not proof. The associated ACPI
D-Notifier warnings are supporting context, not an independently established
root cause. Freezing during active work shortly after wake fits this bug.

### Separate findings / exclusions

- September 3: a distinct AMD/TTM NULL-pointer crash in
  `ttm_lru_bulk_move_tail`, followed by CPU lockups, on linux 7.1.9.
- September 10: AMD GPU page fault and ring timeout involving Chromium, also
  on linux 7.1.9. **This NVIDIA patch does not fix either AMD failure.**
- No OOM kills, critical-temperature events, or storage errors were found in
  the checked September 1–17 kernel logs. This is not a hardware-health test.
- The machine has AMD 890M + NVIDIA RTX 5080 Mobile hybrid graphics. The active
  external DP-1 output is NVIDIA-owned; the internal eDP panel is AMD-owned.

## Why linux-omarchy appeared

Omarchy 4.0.4 installed linux-omarchy on September 16 at 12:47. Its packaged
migration `/usr/share/omarchy/migrations/1789325478.sh` intentionally retains the
old Arch kernel for recovery. Both entries boot the same installed OS/files.
The configured Omarchy stable mirror was still frozen at September 8 for
Arch packages and supplied NVIDIA 610.57.04; the live Arch package API already
listed 615.71.09. Merely selecting another kernel does not change this driver.

## Applied repair

User chose a backport rather than moving ahead of Omarchy's package set.

- [`nvidia-difr-suspend-resume.patch`](nvidia-difr-suspend-resume.patch): exact
  `nvkms-evo.c` patch hunks from NVIDIA release commit
  `e394a404108a9ce5bba988c1dddf694dabbd4a43` (595.99.02), compared with
  `51edebee79919b54f498c19a0be31982cd97646e` (595.71.05).
- Installed patch: `/etc/dkms/nvidia/patches/nvidia-difr-suspend-resume.patch`.
- [`nvidia-610.57.04.conf`](nvidia-610.57.04.conf) installed at
  `/etc/dkms/nvidia-610.57.04.conf`. It applies only to this driver version,
  the DMI model `ProArt P16 H7606WW_H7606WW`, and kernel releases ending in
  `-omarchy`; other models and future driver versions do not inherit it.
- Built and signed in an isolated DKMS tree, then installed using DKMS for
  **7.2.5-3-omarchy only**. Rebuilt its UKI with
  `limine-mkinitcpio linux-omarchy`.
- Stock source files under `/usr/src/nvidia-610.57.04` remain unmodified.
- Plain `linux` UKI and all its NVIDIA modules remain byte-for-byte unchanged.
- No driver downgrade, GSP disabling, suspend-service changes, browser flags,
  monitor changes, loss of automatic locking, or reboot was performed.
- This is the **released lifecycle fix**, not PR #1286's still-unmerged
  timeout/channel-recovery proposal. It does not bound every possible GPU wait.

## Cross-machine sync safety

- `install.sh` excludes `omarchy/` from its portable manifest and rejects it even
  when explicitly requested. The post-update hook does not invoke this repair.
- The installed `/etc/dkms/` files are machine-local regular copies, not Stow
  symlinks. Pulling this repository cannot activate or alter the repair.
- Even if the DKMS override is manually copied onto another laptop model, its
  hardware guard selects no patch. The diagnostic checker skips other models
  with exit 77 before reading driver files or creating temporary files.
- Shared shell, desktop, monitor, browser, and portable installer configuration
  were not changed by this repair.

Run the non-privileged regression check (uses a temporary HOME and simulated DMI):

```sh
python3 ~/dotfiles/omarchy/test-nvidia-difr-portability.py
```

It checks default installation, explicit rejection, the ProArt target, Intel and
other NVIDIA laptops, missing DMI, and exclusion of non-Omarchy kernels.

## Verification

Completed:

- Patch hunks matched the official release comparison exactly; applied to the
  installed source with `--fuzz=0` (line offsets only).
- Full isolated DKMS build passed; modules signed; version and kernel vermagic
  match the installed driver/kernel.
- Extracted the rebuilt UKI and compared all four embedded NVIDIA modules
  byte-for-byte with the installed patched build.
- Verified SHA-256 of the untouched stock-kernel UKI and all five NVIDIA modules.
- Modeset ELF build ID: `80a1789286c8da2e2692d54c58e32b17d80fbf45`.
- Modeset compressed-module SHA-256:
  `a172b9cd18b36db97d854c781e8c3aa83ff0202efb4eac957a81a0542b8c1aa8`.
- Patched UKI SHA-256:
  `87761089b1d933ec10cf41cb30d79ac09809330435c55ca7244c5766809a7fe2`.

**Pending:** save work, reboot and choose **Omarchy → linux-omarchy**, then run:

```sh
~/dotfiles/omarchy/check-nvidia-difr.sh
```

Exit 0 means this verified patched build is loaded. Exit 2 means the old driver
is still loaded and reboot is needed. Exit 77 means another laptop model was
safely skipped. Other failures require inspection. This
check is deliberately specific to this kernel/build; revalidate it after updates.
`uname -r`, NVIDIA's version, and even module `srcversion` alone cannot prove the
patch is loaded: `srcversion` did not change for this OS-agnostic source patch.
The check compares the actual loaded ELF build-ID note instead.

After saving work, manually test repeated suspend/resume with the external
monitor connected, including normal window/browser activity for several minutes
after each resume. Aim to exceed the previous 8–10-cycle window, then observe
normal use over several days. Do not call stability verified before that.

```sh
journalctl -b -k --no-pager --grep='blocked for more than|nvWriteGpEntry|nvDIFR|Oops:|BUG:|ring .*timeout|NVRM: Xid'
```

## Recovery and maintenance

Root-only backups and build/install logs:

```text
/var/lib/nvidia-difr/610.57.04-7.2.5-3-omarchy/
```

Contains the original UKI (`original.efi`), Limine config, installed modules,
DKMS build artifacts, before/after fingerprints, and the isolated patched build.
One initial DKMS archive import hit the installed-version re-registration error;
automatic rollback restored and checksum-verified all originals before retrying
with verified build artifacts and the normal DKMS installer.

If the patched kernel does not boot, select the untouched **Omarchy → linux**
entry (not a snapshot). It is a recovery path, not a known freeze-free kernel.

To remove this backport while retaining the current boot menu and kernel options,
run these commands in an interactive terminal. Do not run them during an update:

```sh
sudo bash -eu <<'SH'
base=/var/lib/nvidia-difr/610.57.04-7.2.5-3-omarchy
kernel=7.2.5-3-omarchy
test "$(< /sys/class/dmi/id/product_name)" = 'ProArt P16 H7606WW_H7606WW'
test -d "$base/original-dkms"
test -d "$base/installed-modules"
test "$(pacman -Q nvidia-open-dkms)" = 'nvidia-open-dkms 610.57.04-1'
test ! -e /var/lib/pacman/db.lck
rm -f /etc/dkms/nvidia-610.57.04.conf /etc/dkms/nvidia/patches/nvidia-difr-suspend-resume.patch
cp -a "$base/original-dkms/." "/var/lib/dkms/nvidia/610.57.04/$kernel/x86_64/"
cp -a "$base/installed-modules/." "/usr/lib/modules/$kernel/updates/dkms/"
depmod "$kernel"
limine-mkinitcpio linux-omarchy
SH
```

Verify image generation succeeded before rebooting. The original UKI and matching
Limine config are also retained for emergency restoration. Do not restore these
old modules over a newer driver release.

Once Omarchy ships a driver containing the released fix, use its normal update
path. The version-specific override becomes inactive automatically; remove its
two `/etc/dkms/` files and retire this build-specific check after verification.
Do not pin NVIDIA indefinitely to this local backport.
