#!/usr/bin/env python3
"""No root or system writes: test the installer and simulated DMI identities."""

import os
import subprocess
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parent.parent
repair = root / "omarchy"
target = "ProArt P16 H7606WW_H7606WW"
dmi_path = "/sys/class/dmi/id/product_name"

with tempfile.TemporaryDirectory() as directory:
    temporary = Path(directory)
    home = temporary / "home"
    home.mkdir()
    environment = {**os.environ, "HOME": str(home), "XDG_STATE_HOME": str(home / ".state")}
    result = subprocess.run(
        ["bash", str(root / "install.sh"), "--dry-run"],
        env=environment, text=True, capture_output=True, check=True,
    )
    packages = next(line for line in result.stdout.splitlines() if line.startswith("dotfiles: packages:"))
    assert "omarchy" not in packages.split(), "Machine-specific repairs entered portable manifest"
    assert not list(home.iterdir()), "Dry run modified the target home"

    result = subprocess.run(
        ["bash", str(root / "install.sh"), "--dry-run", "omarchy"],
        env=environment, text=True, capture_output=True,
    )
    assert result.returncode != 0 and "not a Stow package" in result.stderr
    assert not list(home.iterdir()), "Rejected package modified the target home"
    hook = root / "omarchy-hooks/.config/omarchy/hooks/post-update"
    assert "nvidia-difr" not in hook.read_text(), "Repair added to automatic update hook"

    model_file = temporary / "product_name"
    config = temporary / "nvidia.conf"
    checker = temporary / "check.sh"
    # Redirect only the fixed DMI read in temporary copies; never modify /sys.
    config.write_text((repair / "nvidia-610.57.04.conf").read_text().replace(dmi_path, str(model_file)))
    checker.write_text((repair / "check-nvidia-difr.sh").read_text().replace(dmi_path, str(model_file)))
    probe = '''
source "$1"
for kernel in 7.2.5-3-omarchy 7.1.9-arch1-2 7.2.5-cachyos; do
  if [[ ${PATCH[0]-} && $kernel =~ ${PATCH_MATCH[0]-^$} ]]; then
    printf '%s\n' "$kernel"
  fi
done
'''
    for model in (target, "Yoga Pro 7 14IAH10", "Different NVIDIA laptop", None):
        model_file.unlink(missing_ok=True)
        if model is not None:
            model_file.write_text(model + "\n")
        result = subprocess.run(
            ["bash", "-eu", "-c", probe, "probe", str(config)],
            text=True, capture_output=True, check=True,
        )
        expected = "7.2.5-3-omarchy\n" if model == target else ""
        assert result.stdout == expected, f"Unexpected patch selection for {model}: {result.stdout!r}"
        if model != target:
            result = subprocess.run(["bash", str(checker)], text=True, capture_output=True)
            assert result.returncode == 77 and result.stdout.startswith("SKIP:"), result
    assert not list(home.iterdir()), "Portability checks modified the target home"

print("PASS: portable installer excludes/rejects omarchy; update hook does not invoke repair.")
print("PASS: DKMS patch applies only to the target ProArt model and Omarchy kernels.")
print("PASS: Intel, other NVIDIA, and missing-DMI systems remain unaffected; checker skips them.")
