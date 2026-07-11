---
role: designer
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-11T10:59:03Z -->

designer job (endojs/endo-but-for-bots). Follow-up to PR #124 review by
kriskowal (comment https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548818899,
designs/daemon-endor-pet-store-sqlite.md line ~226, the "What we explicitly do
NOT generalise" section).

Post a design for the SQLite binding surfaces that PR #124 explicitly declined
to generalise, since the maintainer expects them to become a dependency of
future work: JSON1 / FTS5 / R-tree extensions, user-defined functions
(`db.function(...)`), the backup API, multiple-database `ATTACH`, and custom
collations. Scope each, note which future features need it, and sketch the host
binding shape. Land as a draft design PR against `llm`.
