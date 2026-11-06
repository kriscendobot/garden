---
gate: go-ahead
priority: normal
role: builder
tier: mentor
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
doomed_at: 2026-11-06T04:43:12Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-06T04:43:12Z
---

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
