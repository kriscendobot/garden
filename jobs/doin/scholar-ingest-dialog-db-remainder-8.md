role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific
commit (`git log -1 main -- <path>`) still equals the recorded source_commit and
whose sections already exist. A scratch clone is at scratch/dialog-db-src (fetch
main before reading).

The entire notes/ prose corpus is now ingested EXCEPT the two large/companion
files below and the two subdir files. Cycles so far:
- scholar-ingest-dialog-db through -remainder-6: flagship docs, sync/version-control/
  query-engine/glossary, query-planner/rules/scope, data-model, optional-fields +
  incremental/causal, notes/ STORAGE cluster (repository/memory-layout/subject-routing).
- scholar-ingest-dialog-db-remainder-7 (2026-07-06): notes/guide.md "Optionality in
  the query engine" = 8 sections (running-example-and-two-layers, absent-is-a-claim,
  consuming-optional-values-filter-by-default, producing-values-heads-are-contracts,
  negation-and-absence, where-errors-surface, inference-in-an-open-world,
  why-it-is-layered-this-way). Cross-referenced into optional-attribute-query and
  set-widening-type-system concepts; keywords added. commit 3cd6607a.

Remaining, in suggested priority order (respect 3-5 sources / ~25 sections per
cycle; post a further follow-on for whatever is left):

1. notes/notation.md — ~1713 lines, the query notation reference. Its own FULL
   cycle. Companion file notes/notation/schema.json (~17KB JSON schema) — ingest as
   a schema-reference section or two alongside it. Topic: datalog-query.

2. notes/dbsp/findings.mds (~9KB) — the DBSP findings companion to the already-
   ingested notes/dbsp.md; ties to demand-driven-incremental-maintenance /
   change-propagation. Small; can share a cycle with #3.

3. Rust crate docs (topic: content-addressed-storage / ucan-authorization / new
   crate topics as needed). Substantial ones, largest first:
   rust/dialog-query/README.md (316), rust/dialog-repository/Guide.md (273) +
   README.md (98), rust/dialog-capability/README.md (103), rust/dialog-effects/
   README.md (79), rust/dialog-csv/README.md (60), rust/dialog-remote-s3/README.md
   (55), rust/dialog-remote-ucan-s3/README.md (51), rust/dialog-storage/README.md
   (37), rust/dialog-operator/README.md (34), rust/dialog-ucan/README.md (34).
   SKIP the empty/trivial stubs (dialog-common 0, dialog-diagnose 0,
   dialog-artifacts 3, dialog-dbsp 5 lines) unless they gain content — note them
   skipped. Other crates (dialog-blobs, dialog-credentials, dialog-encoding,
   dialog-macros, dialog-network, dialog-search-tree, dialog-varsig,
   dialog-ucan-core) had no README at this HEAD; re-survey.

4. TypeScript: typescript/dialog-experimental (src/lib.ts, session.ts, react.ts,
   package README) and typescript/dialog-artifacts-web-tests.

5. adr/ — currently ONLY adr/000-template.md (355 bytes) + adr/Readme.md (365
   bytes); no populated decision records exist yet. DEFER until real ADRs land;
   note the skip.

Existing dialog-db topics: datalog-query, local-first-sync, ucan-authorization,
change-propagation, content-addressed-storage. Existing concepts include dialog-db,
fact-triple, prolly-tree, merkle-crdt, schema-on-read, ucan-delegation, record-value,
formula-scheme, optional-attribute-query, claim-projection, set-widening-type-system,
demand-driven-incremental-maintenance, divergence-clock, value-based-cas,
profile-account-operator, signer-verifier-credential, subject-routing. Keep
cross-referencing to endo design material where concepts meet (ocap /
capability-security, content-addressed / durable storage, confinement, persistence).
No fork or upstream actions.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 17
  claimed_at: 2026-07-06T15:31:19Z
