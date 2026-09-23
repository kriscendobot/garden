---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-06T16:14:36Z
---
result: scholar-ingest-dialog-db-remainder-10 — dialog-db rust/dialog-query/README.md ingested

Cycle: ingested the query-engine crate doc (a full cycle on its own, 316 lines).
Source clone scratch/dialog-db-src at HEAD f777fe7c; dialog-query README file-specific
commit ebd8f739 (2026-07-01, Irakli Gozalishvili).

Ingested (1 source, 7 sections):
- dialog-db--rust-dialog-query-readme (source_commit ebd8f739), sections:
  overview, associative-claims, associative-relations, semantic-attributes,
  semantic-concepts, deductive-rules, formulas. All topic datalog-query.
  Framed as the crate-doc (Rust API) face of the notes/concept.md and
  notes/architecture-overview.md prose; cross-references those notes sections
  rather than restating rationale.

Concepts:
- NEW concept dialog-query-rust-api (the crate's Rust surface: the! macro,
  Term/Term::<The>, #[derive(Attribute)] with #[domain]/#[cardinality(many)],
  #[derive(Concept)] + Query<T>, deductive rules as fn(Query<T>)->impl When via
  Session::install, #[derive(Formula)] + built-in catalog). See-also to
  dialog-notation, fact-triple, schema-on-read, deductive-rule, formula-scheme.
- Section rows added to existing concepts: fact-triple (associative-claims),
  dialog-notation (associative-relations), schema-on-read (semantic-concepts),
  deductive-rule (deductive-rules), formula-scheme (formulas).

Indexes updated: topics/datalog-query.md (7 Sections rows), sources/README.md
(1 row), concepts/README.md (1 row), keywords.md (13 new keyword lines for
dialog-query-rust-api). topics/README.md datalog-query row already present;
Sections count regenerated.

Skipped this cycle (deferred to follow-on): none re-checked for idempotency this
cycle beyond dialog-query (which was new).

Integrity gate (step 8): library-link-check.sh --source-slug
dialog-db--rust-dialog-query-readme = OK (exit 0); --changed = OK; topics-counts
--check = current (exit 0).

Regenerated (step 9): sections/README.md (regenerate-sections-index.sh) and
topics/README.md Sections-count column (regenerate-topics-counts.sh) both landed
current via land-journal-edit.sh.

Follow-on posted: scholar-ingest-dialog-db-remainder-11 — remaining rust crate docs
(dialog-repository Guide.md+README.md as one cycle; the storage cluster dialog-csv
/dialog-remote-s3/dialog-remote-ucan-s3/dialog-storage as one cycle), TypeScript
(dialog-experimental, dialog-artifacts-web-tests), and adr/ (still deferred — no
populated ADRs). Confirmed still-stub crates (dialog-artifacts/common/dbsp/diagnose)
and still-README-less crates (dialog-blobs/credentials/encoding/macros/network/
search-tree/ucan-core/varsig) recorded in the follow-on for re-survey.
