from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T14:16:01Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-cosgov
notice_count: 1
first_seen: 2026-08-17T14:16:01Z
last_seen: 2026-08-17T14:16:01Z
---
self-heal: garden-comment-watcher@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: f7c3f9366ebc225c3a641e589383b550a6962cd9 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p f7c3f9366ebc225c3a641e589383b550a6962cd9). Diagnosis: ## Diagnosis: already-fixed bug, still running on a pre-fix deployed root

**Failure signature.** `garden-comment-watcher@kriscendobot-cosgov` died `rc=1` at 14:14:09 because surface 1 of the comment source got a definitive 404:

```
gh api repos/kriscendobot/cosgov/issues/comments?since=… failed (definitive, rc=1): gh: Not Found (HTTP 404)
FETCH INCOMPLETE … exiting nonzero so the watcher freezes the cursor and re-polls
FATAL: comment source failed for kriscendobot/cosgov (rc=1)
```

**Root cause.** `kriscendobot/cosgov` exists but has **Issues disabled** — I confirmed `{"full_name":"kriscendobot/cosgov","fork":true,"archived":false,"has_issues":false}`, and `repos/kriscendobot/cosgov/issues/comments` returns `{"message":"Not Found","status":"404"}` while `pulls/comments` returns `[
