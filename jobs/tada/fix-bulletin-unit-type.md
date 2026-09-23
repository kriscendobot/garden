The fix is complete. The unit now holds **active (running)** with `Type=exec`, NRestarts=0, stable MainPID, and the journal shows a clean "Started" (no longer stuck "Starting…").

---

## Completion report: fix-bulletin-unit-type

**Root cause (refined diagnosis):** The source unit `scripts/systemd/garden-bulletin.service` was **already corrected to `Type=exec`** in commit `cf1574cf` ("bulletin: continuous journalist loop with a durable cursor"), and that commit is already on `origin/main2`. The problem was purely a **stale deployment**: the *installed* unit in `~/.config/systemd/user/garden-bulletin.service` still carried the old `Type=oneshot` (with the old "regenerate the journal bulletin" description and no `Restart=`). A `oneshot` unit running a `while` loop never reaches a "started" state — systemd holds it in `activating (start)` indefinitely, exactly the symptom reported. The fix had been committed but never redeployed.

**What I did:**
1. Confirmed the source unit on both `HEAD` and `origin/main2` already had the correct config — `Type=exec`, `Restart=always`, `RestartSec=5`, no `notify`/readiness expectation, no short `TimeoutStartSec`. The git tree is clean; no code change was warranted (re-committing an identical file would be churn).
2. Redeployed: `./scripts/jobs/install-units.sh install` (re-rendered the unit with `@GARDEN_ROOT@` → `/home/kris`, internal `daemon-reload`), then `systemctl --user restart garden-bulletin.service`.
3. Verified the rendered installed unit now reads `Type=exec`.

**Type change:** deployed unit `Type=oneshot` → `Type=exec` (via redeploy of the already-committed source).

**Post-restart state:**
- `is-active`: **active** (was `activating`)
- `ActiveState=active`, `SubState=running`, `Type=exec`
- `NRestarts=0` (stable; MainPID 1573144 unchanged across two checks — not flapping)
- journal shows a clean `Started garden-bulletin.service` line (previously it would stall at `Starting…`)

**SHA:** `main2` HEAD `51030653` (== `origin/main2`); the unit fix itself is `cf1574cf`. No new commit/push was required — the correct source was already landed on `origin/main2`; the gap was deployment only.

**Follow-up:** Worth noting for operators that a config-only fix to a systemd unit requires `install-units.sh install` + `systemctl --user restart` to take effect; committing the unit source alone leaves the running service stale. Other hosts running `garden-bulletin.service` should redeploy if they haven't since `cf1574cf`.
