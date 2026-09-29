from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-26T02:46:35Z
watchdog_key: self-heal-garden-comment-watcher-endojs-endo-but-for-bots
notice_count: 1
first_seen: 2026-09-18T22:23:57Z
last_seen: 2026-09-26T02:46:35Z
---
self-heal: garden-comment-watcher@endojs-endo-but-for-bots exited rc=1 with no scoped fix. Capture: 13b8fc2e2e10399982af630dd2949fc0a352d86f (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 13b8fc2e2e10399982af630dd2949fc0a352d86f). Diagnosis: Diagnosis: the comment-watcher for `endojs-endo-but-for-bots` found its `verify` journal clone corrupt (`clone_is_corrupt` in `scripts/jobs/common.sh:4292` — a missing/broken `origin/journal2` tracking ref) and triggered `reclone_clone` to self-heal. `reclone_clone` (common.sh:4302-4316) deliberately makes only **one** bounded network attempt (`GARDEN_CLONE_RETRIES=1`), by design, per the comment at common.sh:4305-4307: journal callers own their own outer retry/cadence, and this primitive stays single-attempt so nested retry budgets don't multiply. That one `git clone git@github.com:kriscendobot/garden.git` attempt hit the 45s `GARDEN_FETCH_TIMEOUT` and was killed (rc=124), so `reclone_clone` called `die`, exiting 1 — which is exactly the documented behavior: fail loud on one bad netwo
