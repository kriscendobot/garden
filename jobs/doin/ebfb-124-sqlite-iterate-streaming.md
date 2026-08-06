---
role: designer
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:43:29Z cleared=none -->

designer job (endojs/endo-but-for-bots). Follow-up to PR #124 review by
kriskowal (comment https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548814861,
designs/daemon-endor-pet-store-sqlite.md line ~222, "Out of scope for v1").

Design the lazy row-streaming path deferred in the sqlite-bindings design:
add a `hostSqliteStmtNext(stmt)` host function returning one row at a time and
expose it from the shim as `stmt.iterate()`, so `listPetStoreEntries` need not
read every `(storeNumber, storeType)` row into memory in a single allocation at
startup. Maintainer directive: conduct this follow-up AFTER PR #124's sqlite
bindings work is landed/conducted to the `llm` branch. Land as a draft design
PR against `llm` per roles/designer/AGENT.md.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-06T05:43:39Z
