---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/complete-job.sh` and `scripts/jobs/gardener.sh` crash the whole cleric worker process on an unposted handoff successor instead of requeuing just the job.

Failure signature: `FATAL: handoff successor '<X>' is not durably posted on the board` followed by `FATAL: complete-job failed for '<base>' (rc=1)` in the garden-cleric log, then service exit 1 / systemd restart (seen this run on `kriscendobot-minion.town-pr68-review-45cc89f1`, declared successor `kriscendobot-minion-town-pr68-gauntlet`, never posted to `jobs/{plan,todo,doin,tada}`).

Root cause: `handoff_successor_posted` correctly rejects the unposted successor and `complete-job.sh:157` calls `die` (`common.sh:409`, a bare `exit 1`). That rc reaches `gardener.sh:699`:
```
[ "$crc" -ne 0 ] && die "complete-job failed for '$base' (rc=$crc)"
```
which is the only completion-outcome branch that doesn't special-case a recoverable rc (contrast the offline-rc branch just above it, and the sibling deterministic gates `assert-followup-posted.sh`/`assert-design-pr-gauntlet.sh` a few lines earlier, which log and leave the job in `doin` for the reaper without killing the process). So a routine worker mistake (declaring a handoff to a basename it never actually ran `post-job.sh`/`post-plan.sh` on) takes down the entire long-running gardener/cleric process instead of just failing that one job.

Fix: give the "handoff successor not durably posted" case its own non-fatal exit code out of `complete-job.sh` (parallel to `GARDEN_OFFLINE_RC`, e.g. a new `GARDEN_HANDOFF_UNVERIFIED_RC` constant in `common.sh`), and in `gardener.sh:699` handle that code the same way the offline-rc branch already does just above it: log `"handoff successor not durably posted for '$base' (rc=$crc); left in doin for TTL requeue"`, clean up the report/capture/sentinel files, and `continue` the loop rather than `die`. Leave every other non-zero `crc` fatal as today — this narrows only the one known-recoverable case.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-01T23:34:18Z
