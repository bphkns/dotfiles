# wireplumber

## Bluetooth muffled audio (Anker PowerConf)

Muffled = device switched to HFP (phone-call profile). Bluetooth Classic can't do hi-fi playback
and mic at once, so WirePlumber flips to HFP whenever any app holds the Anker mic
(autoswitch kept on; Anker mic is the default source and is used in calls).
Live test 2026-09-24: manual A2DP<->HFP switching works; the "Failure in Bluetooth audio transport"
log lines are just the switch tearing down the old transport, not a fault.

So an unexpected muffle means some app grabbed the mic outside a call.

- `fix-audio-muffling` (local-bin): names the apps holding a mic, forces A2DP back.
- `bt-mic-watch` (local-bin + systemd user unit): logs every profile change and the mic holders.
  Next time it muffles: `journalctl --user -u bt-mic-watch -n 20` shows who did it.
