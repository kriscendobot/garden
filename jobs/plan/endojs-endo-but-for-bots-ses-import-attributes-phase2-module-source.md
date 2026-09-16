---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-09-16T13:00:25Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: SES import attributes — Phase 2 (module-source static `with` capture)

Follow-up to PR endojs/endo-but-for-bots#1292 (Phase 1 landed the ses runtime
core of `designs/ses-import-attributes.md`). Base branch `llm`.

Scope (design § Normalized attribute representation, § Memo key extension,
§ Test plan "Parser"):
- Extend `@endo/module-source` to capture the `with { ... }` clause on static
  imports through the babel analyzer; reject duplicate keys (SyntaxError) and
  non-string values at parse time.
- Add `normalizeImportAttributes` / `EMPTY_ATTRIBUTES` to `@endo/module-source`
  (currently only in `ses`); keep byte-identical to the ses copy.
- Rework the precompiled functor / `$h_imports` linking convention and
  `resolvedImports` so two same-specifier static imports with differing
  attributes resolve to distinct instances (the § Memo key extension worked
  example). PRESERVE byte-identity of precompiled sources/archives for
  purely-JavaScript graphs (attributes recorded only on non-empty clauses).
- Land the parser + memo-separation tests from the § Test plan.

Verify: full `packages/ses`, `packages/module-source`, and
`packages/compartment-mapper` suites, plus archive hash-consistency.
Stops at an open DRAFT PR (manual-gauntlet regime).
