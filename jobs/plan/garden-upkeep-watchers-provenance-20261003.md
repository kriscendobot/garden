---
gate: go-ahead
priority: normal
role: fixer
tier: minion
handler-timeout: 7200
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: deterministic
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-10-03T05:23:10Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-10-03T05:23:10Z
---

---
role: fixer
requires: host=endolin-garden-ece02cb4
handler-timeout: 7200
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Garden upkeep on the leader: blind comment watchers, provenance gap, bloated repo-watcher clone

Maintainer (kriskowal, muster 2026-10-03) approved this disposition.

1. comment-watcher self-tests FAIL on kriscendobot/test262 and kriscendobot/vattr97 (the
   comment source path cannot fetch a known-existing comment, so the watchers are blind).
   Diagnose and fix in scripts/jobs (main2); verify the self-test passes on the leader.
2. watchdog comment-provenance-gap-endolin-garden-ece02cb4 has fired 14 times since
   2026-10-01T21:44Z. Find the cause and fix it, or explain why it is benign and quiet it.
3. /home/kris/garden/.garden-state/repo-watcher/journal has 1001 packs (>= 1000 guard).
   gc it (or re-clone it) safely while the repo-watcher is idle, and fix whatever lets it
   accumulate packs if that is the root cause.
Land fixes directly on main2 per garden convention. Report what you changed.
