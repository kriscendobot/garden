---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-09-16T13:00:36Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: SES import attributes — Phase 3 (compartment-mapper plumbing)

Follow-up to PR endojs/endo-but-for-bots#1292 (Phase 1) and the Phase 2
module-source work. Base branch `llm`.

Scope (design § Backward compatibility for serialized bundles,
§ Compartment-mapper implications, § Test plan "Bundle replay"):
- `packages/compartment-mapper/src/link.js`: route non-empty-attribute module
  records through `modulesWithAttributes`; make the synthetic `importHook`
  two-arg (arity 2) so the loader does not gate it against the legacy rule.
- Archive read path: inject `EMPTY_ATTRIBUTES` for pre-attributes entries.
- Archive write path: record attributes only on non-empty `with` clauses, so
  purely-JavaScript graphs stay byte-identical (SHA-pinned archive integrity).
- Synthetic-importHook construction dispatches on `[specifier, attributes]`.
- Land the "Bundle replay" test: a pre-attributes archive loads identically and
  its single-arg synthetic hook still satisfies specifier-only imports.

Verify: full `packages/compartment-mapper` suite incl. hash/round-trip.
Stops at an open DRAFT PR (manual-gauntlet regime).
