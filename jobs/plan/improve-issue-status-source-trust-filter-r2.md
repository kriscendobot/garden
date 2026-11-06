---
gate: orchestrated
orchestrated_by: muster-improve-fixes-r2-20261106
priority: normal
posted_by: liaison
posted_at: 2026-11-06T02:08:55Z
---

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

