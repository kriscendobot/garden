# Fix misplaced CollectMode in systemd unit templates

systemd logs a warning on every gardener (re)start:

```
garden-gardener@.service:9: Unknown key name 'CollectMode' in section 'Service', ignoring.
```

`CollectMode=` is a **[Unit]** directive, but in `scripts/systemd/garden-gardener@.service`
it sits in the **[Service]** section (line 9), so systemd ignores it.

## Task

1. In `garden/scripts/systemd/garden-gardener@.service`, move
   `CollectMode=inactive-or-failed` out of `[Service]` and into the `[Unit]`
   section.
2. Grep the rest of `garden/scripts/systemd/*.service` for the same
   misplacement (`CollectMode` under `[Service]`) and fix any others the same way.
3. Re-render and reload the units to confirm the warning is gone:
   `garden/scripts/jobs/install-units.sh install`, then
   `systemctl --user daemon-reload` and restart one gardener instance
   (`systemctl --user restart garden-gardener@1.service`) and confirm
   `journalctl --user -u garden-gardener@1.service` no longer logs the
   CollectMode warning.
4. Commit the unit-template fix to the `main2` branch (bot identity).
   Run shellcheck on any shell script you touch (house convention).

## Deliverable

A `tada` report: which unit files were fixed, the commit SHA on main2, and
confirmation the daemon-reload no longer warns about CollectMode.

---
claim:
  host: endolinbot
  gardener: 63
  claimed_at: 2026-06-24T09:30:19Z
