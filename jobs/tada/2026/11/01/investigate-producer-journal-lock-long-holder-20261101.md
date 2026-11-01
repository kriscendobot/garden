The work for this job was fully completed and pushed by the prior attempt before it hit a handler failure and was requeued. I have re-derived the state, verified the committed fix addresses every job item, and confirmed the tests pass.

## Completion report

**Finding:** The substantive work for this investigation was already committed and pushed to `main2` as `7a27474163b` ("fix(locks): bound watchdog-notice, name lock holders, stop futile live steals", 2026-11-01 05:04:45Z) by the prior claimant (endolin monk-3). That attempt completed and pushed the fix but then hit a non-transient handler failure (`5702f8e9236 terminal-failure`) and was requeued to me. The commit is already live on `origin/HEAD`; nothing remained to write.

**Root cause identified** (the "which producer holds the clone 30 min" question): the pid-708218 holder was a **detached handler-budget-overrun alert** from gardener.sh `alert_maintainer` → `watchdog-notice.sh`. Its unbounded CAS loop (up to 50 attempts) re-grabbed `clone_lock` across each journal fetch, which itself retried 3×45s against a degraded remote — starving every other producer with rc=75 for ~30 minutes.

**Fixes verified in `7a27474163b`, mapped to the three job items:**

1. **Bound the long holder + name it** — `watchdog-notice.sh` now enforces a `GARDEN_POST_DEADLINE_SECS` (300s) wall-clock deadline (exits `GARDEN_OFFLINE_RC`/75), modeled on `post-job.sh`; it also distinguishes a fetch failure (new rc=3) from a lost push race. Repo-lock, fetch-lock, and clone-lock holder records now carry `script=…/tag=…/unit=…` via the new `garden_lock_identity()`, printed in the `overdue-holder pid=N` diagnostic. `alert_maintainer` keeps the folded occurrence count on a give-up so no alert is lost.

2. **TTL steal decision** — confirmed the stale-steal is futile against a *live* holder on a git clone (it still holds the nested repository flock, so the stealer only blocks `GARDEN_REPO_LOCK_WAIT` then exits 75 anyway). `clone_lock` now detects a live-but-overdue holder, records a `lock-giveup` contention sample, names the holder, and skips the tick immediately (rc=75) **without unlinking** its lock file. Dead holders and non-git dirs are still reclaimed as before.

3. **Leaked `fetch.lock.holder.<pid>` records (low priority)** — `_garden_repo_fetch` now sweeps dead holder records (shared `_garden_lock_clear_dead` helper) so a fetch killed by its timeout no longer accumulates stale records per key.

**Tests (all pass):** `repo-locks-test.sh` (incl. new "holder record names the script, tag, and unit" and "dead fetch holder records are swept"), `stale-lock-test.sh` (13/13, incl. "live holder's lock file not unlinked", "skip names the holder's unit", "skip was immediate, no retry ladder"), and `watchdog-notice-cas-test.sh` ("gives up at the wall-clock deadline when the journal is unreachable").

**Worktree:** clean; HEAD == origin/main2 == `7a27474163b`. No new commit needed; no follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-producer-journal-lock-long-holder-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 112 tokens (7022859 cached reads)
- Output: 40175 tokens
- Cost: $4.2861820999999996
- Wall-clock: 690s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
