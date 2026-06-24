# Guard mentor.sh's journalctl probe with a timeout (it can hang indefinitely)

`scripts/jobs/mentor.sh` line ~49 gathers service failures with:

    jlog="$(journalctl --user -u 'garden-*' -p warning --since "$since" --no-pager 2>/dev/null || true)"

The `|| true` tolerates a non-zero *exit*, but NOT a *hang*. In a headless
`claude -p` / cron context where the `--user` journal/dbus connection cannot be
established, `journalctl --user` blocks indefinitely, so the whole mentor tick
wedges and never produces improvement jobs (the self-healing loop silently
stalls). Observed live on 2026-06-24: a mentor invocation hung ~2min on this
exact call until the journalctl process was killed by hand.

## Fix
Wrap the probe in `timeout` so a stuck journal connection degrades to an empty
digest instead of a hang:

    jlog="$(timeout 30 journalctl --user -u 'garden-*' -p warning --since "$since" --no-pager 2>/dev/null || true)"

Pick a conservative bound (15-30s). Confirm `bash -n` / shellcheck clean. If the
same `journalctl --user` pattern appears in other long-running service scripts,
apply the same guard there. Build in an isolated worktree off origin/main2 per
the infra-job discipline; push HEAD:main2 under the bot identity.

---
claim:
  host: endolinbot
  gardener: 28
  claimed_at: 2026-06-24T22:30:33Z
