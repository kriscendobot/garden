from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T14:09:15Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-ocapn
notice_count: 1
first_seen: 2026-08-17T14:09:15Z
last_seen: 2026-08-17T14:09:15Z
---
self-heal: garden-comment-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: 3e6a6d88f86f7d6b664278e542e2c1a5bd3d7f2d (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 3e6a6d88f86f7d6b664278e542e2c1a5bd3d7f2d). Diagnosis: ## Diagnosis: already fixed on `main2`; this host is 10 commits behind — no fix job warranted

**Failure signature.** `garden-comment-watcher@kriscendobot-ocapn` exits 1 because surface 1 permanently 404s:

```
gh api repos/kriscendobot/ocapn/issues/comments?since=…  →  gh: Not Found (HTTP 404)  (definitive, rc=1)
FETCH INCOMPLETE … exiting nonzero so the watcher freezes the cursor and re-polls
FATAL: comment source failed for kriscendobot/ocapn (rc=1)
```

**Root cause, reproduced.** `kriscendobot/ocapn` (fork of `ocapn/ocapn`) has **Issues disabled**:

- `gh api repos/kriscendobot/ocapn --jq .has_issues` → `false`
- `repos/…/issues/comments` → HTTP 404 **permanently**, while `repos/…/issues` → `[]` and `repos/…/ocapn` itself answers 200.

So in the *deployed* `scripts
