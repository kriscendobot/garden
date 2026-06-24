---
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
section_count: 10
status: current
notes: Largest single source ingested so far (1168 lines, 37 H2 sub-sections). Consolidated at H1 boundaries with Operations (9 H2 ops) and Descriptors (7 H2 descs) each kept as one section rather than per-H2-split. Each consolidated section preserves H2 boundaries inline so an agent can find a specific operation or descriptor by H2 anchor. A future cycle could split Operations or Descriptors if specific entries become frequent lookups.
---

> Abstract: The upstream protocol's CapTP specification (draft). The complete wire-level account of how OCapN peers exchange capability-bearing messages: session establishment, promise handling and pipelining, cryptography (public keys, identifiers, session IDs, signatures), three-party handoffs, the bootstrap object's three methods, 9 wire operations (op:start-session through op:gc-answers), 7 descriptor types (desc:import-object through desc:handoff-receive), and a closing history section. Authored by Jessica Tallon (2026-03-12).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/ocapn--draft-specifications-captp--overview.md) | ocapn, captp | current |
| [captp-overview](../sections/ocapn--draft-specifications-captp--captp-overview.md) | ocapn, captp | current |
| [promises](../sections/ocapn--draft-specifications-captp--promises.md) | ocapn, captp, eventual-send | current |
| [cryptography](../sections/ocapn--draft-specifications-captp--cryptography.md) | ocapn, captp | current |
| [third-party-handoffs](../sections/ocapn--draft-specifications-captp--third-party-handoffs.md) | ocapn, captp, capability-security | current |
| [bootstrap-object](../sections/ocapn--draft-specifications-captp--bootstrap-object.md) | ocapn, captp, capability-security | current |
| [operations](../sections/ocapn--draft-specifications-captp--operations.md) | ocapn, captp | current (9 H2 ops consolidated) |
| [descriptors](../sections/ocapn--draft-specifications-captp--descriptors.md) | ocapn, captp | current (7 H2 descs consolidated) |
| [history](../sections/ocapn--draft-specifications-captp--history.md) | ocapn | current |
| [funding](../sections/ocapn--draft-specifications-captp--funding.md) | ocapn | current |

## Cross-source overlap with Endo

The captp topic in the library now has substantial coverage from both spec (this source) and implementation (`@endo/captp` README). Notable cross-references:

- `captp-overview` ↔ `endo--pkg-captp-readme--usage` (makeCapTP API; the spec-side wire account vs Endo-side application API)
- `promises` ↔ `endo--pkg-eventual-send-readme--handled-promise` + `endo--pkg-eventual-send-readme--promise-pipelining`
- `third-party-handoffs` ↔ no direct Endo realization yet at the package level; the bootstrap-object methods cover the basic capability flow
- `operations` and `descriptors` are wire-protocol-only; no application-level Endo section maps cleanly. `convertValToSlot` / `convertSlotToVal` in marshal is the application-level bridge

## OCapN spec ingestion complete

After this cycle, all 5 OCapN draft specifications plus the project README are in the library. Total OCapN section count: ~36 (this cycle's 10 + 26 from cycles 16-19 across Model, Notation, Locators, Netlayers, README).

## Provenance

- File last modified 2026-03-12 by Jessica Tallon.
- Captured at upstream commit `8704f69e`.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e`.
