from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T14:10:03Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-list
notice_count: 1
first_seen: 2026-08-17T14:10:03Z
last_seen: 2026-08-17T14:10:03Z
---
self-heal: garden-comment-watcher@kriscendobot-list exited rc=1 with no scoped fix. Capture: 6eed636c387eb7253aeec5c1ce3b95009b216aa9 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 6eed636c387eb7253aeec5c1ce3b95009b216aa9). Diagnosis: ## Diagnosis: both defects are already fixed on `main2` — this host is 10 commits behind on deploy

**What failed.** The `kriscendobot/list` comment source hit two failing surfaces in one tick, and the watcher correctly refused to advance the cursor past un-enumerated comments, exiting nonzero (`comment-watcher.sh` FATAL):

1. `repos/kriscendobot/list/issues/comments` → **HTTP 404**. Reproduced: the repo has `has_issues: false` (it's a fork with Issues disabled), so that endpoint is a permanent 404, not a blip.
2. `repos/kriscendobot/list/pulls/1/reviews` → `unexpected end of JSON input`. Reproduced with `gh api -i`: GitHub is returning **`HTTP/2.0 500 Internal Server Error` with `Content-Length: 0`**. Because `gh api` swallows the status and surfaces only the Go decoder error, the t
