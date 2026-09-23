from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-19T05:53:21Z
doom_base: improve-ci-watcher-outage-latch-flap-dedup
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-19T05:53:21Z
last_seen: 2026-09-19T05:53:21Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-ci-watcher-outage-latch-flap-dedup; it stays HELD until a human promotes it
(promote-plan.sh improve-ci-watcher-outage-latch-flap-dedup) or removes it, so nothing is lost.
Original job base: improve-ci-watcher-outage-latch-flap-dedup

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
The journal-outage latch (`note_journal_outage`/`note_journal_recovered`, ~line 478-520) closes on the first successful fetch after an outage, with no hysteresis. During intermittent (not fully down) journal connectivity, this lets the episode flap open→closed→open repeatedly across the ~15 per-repo watcher instances riding a 90s cadence, each landing on a different side of a brief recovery. Evidence: 2026-09-19 04:53–05:20Z logged 6 separate "host outage episode opened" WARNs across 4 different repo slugs on one host — almost certainly one continuous flaky window, not 6 distinct outages — defeating the latch's stated purpose of collapsing a shared outage into one open+one close. Add debounce: e.g. stamp the close time in the latch dir and require either N consecutive successful `verify_fetch`s or a minimum quiet period (a few minutes) before actually removing the latch/logging "closed"; a failure arriving inside that quiet window should extend the same episode silently rather than opening a fresh loud WARN. Keep the existing sibling-flock serialization; only add the hysteresis state (e.g. `$latch/last_success`) read/written under the same lock.
