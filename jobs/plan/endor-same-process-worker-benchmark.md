---
gate: go-ahead
priority: normal
role: scout
posted_by: gardener
posted_at: 2026-08-06T06:30:32Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Benchmark an endor daemon and worker in one process

Repo: https://github.com/endojs/endo-but-for-bots
Origin: https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3726323682

Promote when the endor platform has an opt-in same-process worker category. Extend the slot-machine benchmark matrix with an endor daemon and worker hosted in the same process. Compare it with the existing Node and separate-process endor variants using the same workload, warm-up, sample count, and reporting format. Record raw samples, median, dispersion, environment, commit, and the exact opt-in configuration. Do not substitute an in-memory transport that bypasses the production same-process worker path.
