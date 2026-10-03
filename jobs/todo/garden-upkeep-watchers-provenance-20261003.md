---
role: fixer
requires: host=endolin-garden-ece02cb4
handler-timeout: 7200
tier: mentor
fallback-tier: minion
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
