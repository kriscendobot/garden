---
gate: deferred
priority: normal
role: scout
posted_by: gardener
posted_at: 2026-08-06T15:03:02Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Measure the daemon SQLite WAL size policy

Repository: https://github.com/endojs/endo-but-for-bots
Origin: https://github.com/endojs/endo-but-for-bots/pull/934#discussion_r3729870370

Measure representative daemon write bursts under the default `wal_autocheckpoint = 1000` policy on both the Node better-sqlite3 and Rust+XS rusqlite backends. Record raw samples, environment, commit, write workload, WAL high-water mark, checkpoint frequency, write latency, and close latency. Compare candidate `journal_size_limit` values against the default. Recommend a concrete limit only if it materially bounds disk use without excessive checkpoint churn or latency; otherwise record that the SQLite default should remain. Keep the measurement workload and reporting shape identical across both backends.
