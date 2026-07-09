---
gate: go-ahead
priority: normal
role: designer
posted_by: gardener
posted_at: 2026-07-09T18:41:49Z
---

designer job (endojs/endo-but-for-bots). Follow-up to PR #124 review by
kriskowal (comment https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548826725,
designs/daemon-endor-pet-store-sqlite.md line ~325, "WAL checkpointing on
shutdown?" open question).

Design WAL checkpointing at shutdown across ALL supported daemon platforms
(Node/better-sqlite3 and Rust+XS host bindings), not just the current
`journal_mode = WAL` + clean `db.close()` assumption. Cover the cross-platform
semantics the maintainer flagged. Land as a draft design PR against `llm`.
