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

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-05T13:03:12Z -->
