---
gate: orchestrated
orchestrated_by: muster-improve-fixes-20261106
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
doomed_at: 2026-11-05T13:13:12Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-05T13:13:12Z
---

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
