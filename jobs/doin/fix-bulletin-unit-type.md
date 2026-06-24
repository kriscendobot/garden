# Fix the garden-bulletin.service unit Type (stuck "activating")

Wear the **mentor** role. The journalist build converted `garden-bulletin.service`
into a long-running loop (`scripts/jobs/bulletin.sh` now runs a `while` loop), but
the unit shows **"activating"** rather than **"active (running)"** even though the
loop process is running. That mismatch means systemd does not consider the service
started — likely a wrong `Type` (e.g. `Type=notify` with no `sd_notify`, or a
`TimeoutStartSec` that will eventually mark the start failed → `Restart=always`
restarts → flapping). The bulletin works for now but the unit is wrong.

Fix on `main2` (**isolated worktree off `origin/main2`** per the infra-job discipline).

## Fix

1. Inspect `scripts/systemd/garden-bulletin.service`. For a bash script that runs
   forever and never signals readiness, set **`Type=exec`** (active once the binary
   execs) — or `Type=simple` — and **remove any `notify`/readiness expectation**.
   Keep `Restart=always` with a sane `RestartSec`; drop or widen any short
   `TimeoutStartSec` that would trip on a loop that never "finishes starting".
2. Confirm the loop itself does not block startup pathologically (e.g. a slow first
   `claude -p` should not prevent the unit reaching active — `Type=exec` avoids that).
3. Redeploy: `install-units.sh install` (re-render the unit) + `systemctl --user
   daemon-reload` + `systemctl --user restart garden-bulletin.service`, then confirm
   `systemctl --user is-active garden-bulletin.service` reports **active** (not
   activating) and that it is not flapping (`systemctl --user show
   garden-bulletin.service -p NRestarts` stays stable).

## Definition of done

`garden-bulletin.service` reaches and holds **active (running)** with the corrected
`Type`, no flapping, committed and pushed to `origin/main2` (bot identity) and
redeployed. Report the SHA, the Type change, and the post-restart state
(is-active + NRestarts). If blocked, report the diagnosis and ready-to-apply unit
file rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 51
  claimed_at: 2026-06-24T22:08:39Z
