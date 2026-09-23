Ingested the dialog-db **query-notation reference** into `journal/library/` (topic `datalog-query`), closing out the `notes/` prose corpus. Only Rust crate docs, one DBSP findings companion, TypeScript packages, and (deferred) ADRs remain.

**Sources ingested (2, both at file-commit `bde506d7`, 2026-07-05):**
- `dialog-db--notes-notation` (`notes/notation.md`, 1713 lines) → **12 sections**: overview, structural-identity, selectors-domains-and-names, attribute, concept, deductive-rules, constraints-and-formulas, assertions-and-claims, and the four abbreviated-notation sections (addressing, attribute, concept, deductive-rules).
- `dialog-db--notes-notation-schema` (`notes/notation/schema.json`, ~17KB) → **1 section**: json-schema (the full JSON-Schema `$defs` graph). Tracked as its own source so its idempotency anchor follows the schema file independently of the prose.

**Concepts:** two new pages — `dialog-notation` (the two one-to-one notations, addressing/inference/punning, 64-byte selector, structural identity) and `deductive-rule` (deduce/when/unless, conjunction, disjunction-as-rules, negation-as-failure, formula/`==` premises). Added an assertions-and-claims row + a See-also to `fact-triple`.

**Indexes:** 13 rows into `topics/datalog-query.md`; 2 rows in the `sources/README.md` dialog-db block; 2 bullets in `concepts/README.md`; 36 keyword lines. All authored in an isolated staging area and landed through `land-journal-edit.sh` (no live-worktree edits).

**Integrity gate (step 8):** PASS — `library-link-check --source-slug` on both notation clusters (with `--wikilinks`) resolves every link to a committed file; topics-count check current.
**Index regeneration (step 9):** `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both ran and landed.

**Follow-up:** posted `scholar-ingest-dialog-db-remainder-9` naming the exact remainder (dbsp/findings.mds, the Rust crate READMEs at ~2-3 cycles, the TypeScript packages, ADRs deferred).

**Self-improvement (surfaced, not landed):** `insert-sections-table-row.sh` matches only a literal `## Sections` heading, so it fails on concept pages (`## Sections that touch this concept`), forcing a by-hand row placement each time — a one-line prefix-match widening would let scholars use the deterministic inserter there too. Routed as an observation, out of scholar scope to land.
