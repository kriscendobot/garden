from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T13:13:22Z
doom_base: improve-issue-status-source-trust-filter
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T13:13:22Z
last_seen: 2026-11-05T13:13:22Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-issue-status-source-trust-filter; it stays HELD until a human promotes it
(promote-plan.sh improve-issue-status-source-trust-filter) or removes it, so nothing is lost.
Original job base: improve-issue-status-source-trust-filter

--- original job body ---
---
posted_at: 2026-11-05T12:52:11Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/handlers/issue-source-gh.sh
scripts/jobs/handlers/issue-source-gh.sh:147-170 joins every recent comment’s parent before the status pass can discard untrusted authors, exhausting its read budget repeatedly (12:21:21Z–12:48:34Z).
Accept the status pass’s maintainer allowlist as an optional deterministic input and filter non-members before parent lookups; preserve the existing unfiltered watcher behavior when unset, and add a regression test for bounded trusted-comment enumeration.
