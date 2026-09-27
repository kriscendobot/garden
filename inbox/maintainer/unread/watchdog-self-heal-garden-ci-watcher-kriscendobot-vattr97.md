from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:59:03Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-vattr97
notice_count: 8
first_seen: 2026-09-27T02:48:19Z
last_seen: 2026-09-27T07:59:03Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T02:48:19Z, latest 2026-09-27T07:59:03Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-vattr97`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-vattr97 exited rc=1 with no scoped fix. Capture: 2f095853ed86d99e45e89b3991f626895c51e4dd (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 2f095853ed86d99e45e89b3991f626895c51e4dd). Diagnosis: The `garden-ci-watcher@kriscendobot-vattr97` FATAL is a recurrence of an already-fixed defect, not a new bug: the clone-lock contention fix (commit `ab66fece68f`, "classify a busy live-holder clone-lock give-up as a transient outage instead of re-raising loud") landed on `origin/main2` ~6 hours ago, but the deployed root checkout at this host is still at `47b41af5a14`, now 29 commits behind `origin/main2` (`cf5fe8e849a7`). The rolling deploy is mid-canary — a new stuck-canary marker for `endolin-garden2-5bcdff64` appeared ~12 minutes ago, well under the escalation threshold, so no action needed there yet. No job to post; this clears on its own once the rolling deploy reaches this host.
