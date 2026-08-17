from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T14:36:25Z
watchdog_key: self-heal-garden-comment-watcher-endojs-endo-but-for-bots
notice_count: 3
first_seen: 2026-08-17T13:33:30Z
last_seen: 2026-08-17T14:36:25Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-08-17T13:33:30Z, latest 2026-08-17T14:36:25Z).
The SAME condition (`self-heal-garden-comment-watcher-endojs-endo-but-for-bots`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

self-heal: garden-comment-watcher@endojs-endo-but-for-bots exited rc=1 with no scoped fix. Capture: 5717e8fa9b3eb904d18ac306fa49847ea91341fa (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 5717e8fa9b3eb904d18ac306fa49847ea91341fa). Diagnosis: ## Diagnosis: upstream GitHub outage on the REST reviews endpoint — no garden fix

**Failure signature.** `scripts/jobs/handlers/comment-source-gh.sh:258` failed its `gh api repos/endojs/endo-but-for-bots/pulls/<n>/reviews?per_page=100` call for 8 of the 9 PRs it polled, each with `HTTP 404`. `gh_api_retry` classified 404 as definitive (correctly — a 404 is normally permanent), so each `note_fetch_failure` fired, the source exited nonzero, and the watcher froze the cursor and declined to advance past un-enumerated comments. That chain is the fail-closed design working as intended, not a defect.

**What the 404 actually is.** The response body is not a REST 404 — it is a *GraphQL* error leaking through the REST surface:

```
{"message":"Not Found","errors":[{"type":"NOT_FOUND","path":
