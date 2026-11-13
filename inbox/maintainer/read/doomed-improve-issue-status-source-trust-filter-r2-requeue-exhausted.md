from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T04:43:54Z
doom_base: improve-issue-status-source-trust-filter-r2
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T04:43:54Z
last_seen: 2026-11-06T04:43:54Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-issue-status-source-trust-filter-r2; it stays HELD until a human promotes it
(promote-plan.sh improve-issue-status-source-trust-filter-r2) or removes it, so nothing is lost.
Original job base: improve-issue-status-source-trust-filter-r2

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:55Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T04:06:43Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/issue-source-gh.sh
scripts/jobs/handlers/issue-source-gh.sh:147-170 joins every recent comment’s parent before the status pass can discard untrusted authors, exhausting its read budget repeatedly (12:21:21Z–12:48:34Z).
Accept the status pass’s maintainer allowlist as an optional deterministic input and filter non-members before parent lookups; preserve the existing unfiltered watcher behavior when unset, and add a regression test for bounded trusted-comment enumeration.
