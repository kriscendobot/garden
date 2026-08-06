---
role: designer
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:43:34Z cleared=none -->

designer job (endojs/endo-but-for-bots). Follow-up to PR #124 review by
kriskowal (comment https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548823737,
designs/daemon-endor-pet-store-sqlite.md line ~313, open question).

Design the `db.pragma()` `simple: true` extension deferred as an open question:
better-sqlite3's `pragma(stmt, { simple: true })` returns a scalar rather than a
row set. The maintainer notes this "will certainly become useful in the future."
Specify the shim + host binding behavior and land as a draft design PR against
`llm`.
