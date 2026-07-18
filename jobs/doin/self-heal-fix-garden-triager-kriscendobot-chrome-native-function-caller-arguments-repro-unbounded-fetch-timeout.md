In `scripts/jobs/triager.sh`, the primary poll fetch at line 117 —
`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"` —
is unbounded, so a stalled fetch hangs until systemd SIGTERMs the whole
`garden-triager@` unit. The captured failure signature is exactly a bash
`Terminated` line immediately followed by `FATAL: fetch failed for <slug>`
(exit 1), which trips self-heal on every network stall.

Fix: wrap that fetch in the same reaper `bounded_clone` uses in `common.sh:723`, i.e.
`timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT" git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`.
`GARDEN_FETCH_TIMEOUT` (45s) and `GARDEN_FETCH_KILL_AFTER` (10s) are already
defaulted in `common.sh`, so no new knobs are needed. Optionally log a distinct
"fetch timed out (>${GARDEN_FETCH_TIMEOUT}s), retrying next tick" on rc 124 (as
`bounded_clone` does at `common.sh:734`) before `die`, so a bounded timeout is
legible in logs and self-heal reports rather than looking like a hard failure.
This makes a hung fetch fail fast and retry on the next tick instead of being
killed by systemd and cascading into a unit failure.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  worker_kind: gardener
  claimed_at: 2026-07-18T14:44:31Z
