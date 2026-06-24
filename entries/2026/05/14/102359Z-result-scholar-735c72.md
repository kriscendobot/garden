---
ts: 2026-05-14T10:23:59Z
kind: result
role: scholar
project: agoric-sdk
---

# Thirty-first scholar cycle — agoric-sdk five-root-document ingest + topic-page backfills

Drained 5 of the 6 priming tasks from cycle 30 (deferring `kriscendobot/ocapn/implementation-guide/Implementation Guide.md` to its own dedicated cycle given its size: 658 lines, ~9 sections).

## Cycle work — agoric-sdk roots

| Source | File-commit | Author | Sections |
|--------|-------------|--------|----------|
| AGENTS.md | 08e3d64d | Turadg Aleahmad | 8 (overview + 7 H2) |
| CONTRIBUTING.md | de2c4cbc | Turadg Aleahmad | 4 (overview-platforms-and-toolchain + tools-contract + landing-prs + integration-tests) |
| SECURITY.md | 8bdc349b | Raphael Salas | 2 (supported-versions + coordinated-disclosure) |
| README.md | 511d4f74 | Michael FIG | 7 (overview + prerequisites + build + test + run-demo + edit-loop + dev-standards) |
| packages/README.md | 917211fe | Turadg Aleahmad | 1 (adding-a-new-package) |

**22 new sections** + 5 new source-index files.

### Soft-flag overlaps surfaced

- agoric-sdk AGENTS.md ↔ endo AGENTS.md — analog files, different repo specifics. Per-repo surface is right for each repo's contributor.
- agoric-sdk SECURITY.md ↔ endo docs/security.md — same Agoric HackerOne destination, different per-repo policy file.
- agoric-sdk CONTRIBUTING.md `tools-contract` ↔ agoric-sdk AGENTS.md `coding-style-and-naming-conventions` — both encode boundary disciplines.
- agoric-sdk README's "endo provides the lower layers" frame — critical for any agent navigating between the two repos.

All overlaps soft-flagged with `notes:` fields per the cycle-30 consolidation conventions.

## Cycle work — consolidation/cross-reference contribution

### Topic-page backfills

While updating topic pages to add this cycle's new rows, discovered **significant drift** between topic-page section tables and the section files actually claiming each topic. Did targeted backfills where the drift was tractable:

- `typescript-conventions.md`: 2 → 12 rows (added agoric-sdk--docs-typescript-* from cycle 28, plus bundle-source/typescript-type-erasure, exo/docs-types/overview that were already in the library).
- `testing.md`: 2 → 10 rows (added contributing--validation, ses-ava--{overview,compatibility,supporting-multiple-configurations} that were orphaned in the topic listing).
- `security-disclosure.md`: 6 → 9 rows (added module-source--bug-disclosure that was missing).

### Drift flagged for future dedicated cycle

Topic pages where the drift is large enough to warrant a dedicated refresh cycle (added explicit `> Note:` callouts on the affected pages):

- `tooling.md`: 5 listed, 41 sections claim the topic. Major refresh needed.
- `bundles.md`: 2 listed, 25 sections claim the topic. Major refresh needed.

A dedicated **topic-page refresh sweep** is now an obvious near-future scholar cycle. The sweep would walk every topic page, grep all sections that claim the topic, and reconcile the listing. This is mechanical work for one cycle.

## Library state

- **304 sections** from **63 source documents** (+22 sections, +5 sources)
- agoric-sdk now has 9 source files ingested (`docs/commit-hygiene.md`, `docs/node-version.md`, `docs/typescript.md`, `docs/env.md`, `AGENTS.md`, `CONTRIBUTING.md`, `SECURITY.md`, `README.md`, `packages/README.md`) — the entire root-level + docs/ corpus is now covered.
- 3 source repos: endojs/endo (49 sources), kriscendobot/ocapn (6), agoric/agoric-sdk (9 — up from 4).

## Inbox state

1 deferred task remaining (the OCapN Implementation Guide). Active mode (~1200s).

## Self-improvement

- The bulk-ingest cadence for a related-document batch (5 small root files) hits ~22 sections in one cycle, right at the budget. Confirmed pattern: 5 sources of mixed size, mostly small, with a planned defer of the one large source to a dedicated cycle.
- Topic-page drift is now a known maintenance debt. The dedicated refresh sweep should be the next obvious cycle once the deferred OCapN guide lands.
- The `agoric-sdk--agents--coding-style-and-naming-conventions` section, by virtue of carrying `[agent-conventions, typescript-conventions, capability-security]`, exemplifies what the topic-pages-as-discovery story is supposed to look like — one section, three topic pages route to it. Cross-topic-page filing is now load-bearing for the library.
