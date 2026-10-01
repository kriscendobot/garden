---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# comment-watcher for kriscendobot/vattr97 is blind (self-test failure)

Watchdog `blind-comment-watcher-kriscendobot-vattr97`: the comment-watcher's
self-test on `kriscendobot/vattr97` failed to fetch a known-existing comment
via its comment-source path — this is positive proof the watcher is silently
blind on this repo (matching the 2026-06-24 `jq`-outage signature), not a
report that the repo is simply quiet.

## Task

Check `jq` and `gh` availability/health on `endolin-garden-ece02cb4`, and the
comment-source handler the watcher uses for `kriscendobot/vattr97`
specifically (rule out a repo-specific cause — a renamed/deleted comment the
self-test still references, a permissions change, a rate-limit state — before
assuming it's the same fleet-wide jq-outage class as 2026-06-24). Fix
whatever's actually broken and confirm the self-test passes afterward.
