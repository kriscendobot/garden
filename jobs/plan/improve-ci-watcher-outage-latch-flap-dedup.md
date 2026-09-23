---
gate: deferred
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-19T05:53:11Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-19T05:53:11Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
The journal-outage latch (`note_journal_outage`/`note_journal_recovered`, ~line 478-520) closes on the first successful fetch after an outage, with no hysteresis. During intermittent (not fully down) journal connectivity, this lets the episode flap open→closed→open repeatedly across the ~15 per-repo watcher instances riding a 90s cadence, each landing on a different side of a brief recovery. Evidence: 2026-09-19 04:53–05:20Z logged 6 separate "host outage episode opened" WARNs across 4 different repo slugs on one host — almost certainly one continuous flaky window, not 6 distinct outages — defeating the latch's stated purpose of collapsing a shared outage into one open+one close. Add debounce: e.g. stamp the close time in the latch dir and require either N consecutive successful `verify_fetch`s or a minimum quiet period (a few minutes) before actually removing the latch/logging "closed"; a failure arriving inside that quiet window should extend the same episode silently rather than opening a fresh loud WARN. Keep the existing sibling-flock serialization; only add the hysteresis state (e.g. `$latch/last_success`) read/written under the same lock.
