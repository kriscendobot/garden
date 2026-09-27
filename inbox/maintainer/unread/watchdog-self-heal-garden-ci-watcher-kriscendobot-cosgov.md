from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:03:17Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-cosgov
notice_count: 7
first_seen: 2026-09-27T01:56:24Z
last_seen: 2026-09-27T07:03:17Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-27T01:56:24Z, latest 2026-09-27T07:03:17Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-cosgov`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: 725323c03898447d04f148d51b243e5468955d84 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 725323c03898447d04f148d51b243e5468955d84). Diagnosis: This confirms deploy lag: `.garden-state/deploy/last-deploy.log` shows an in-progress drain still waiting for mid-job gardeners, and the root checkout (currently at `47b41af5a14`) is **19 commits behind `origin/main2`**. Critically, the exact fix for this signature is upstream but not yet deployed:

- `5620bdbe5f6` — "fix: isolate CI watcher clones per slug"
- `e6ea1d33fc8` — "fix(jobs): skip quietly on live-holder clone-lock contention in ensure_clone_or_latch_outage"

...plus 7 more clone-lock-contention fixes layered on top of those (`c38cb55b172`, `ab66fece68f`, `1570aa85a47`, `4692b4df0e7`, `9dbda9d5573`, `4948cdd9a75`, `ad55dea66f9`, `49cf6544668`). None of these are ancestors of HEAD yet.

The failure signature (`cannot acquire clone lock .../verify.lock after 3 waits ... a live
