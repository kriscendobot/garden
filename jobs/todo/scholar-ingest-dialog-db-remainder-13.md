role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific commit
(`git log -1 main -- <path>`) still equals the recorded source_commit and whose
sections already exist. Scratch clone at scratch/dialog-db-src (fetch main first).

As of remainder-12 (2026-07-06, landed): the STORAGE CLUSTER is FULLY ingested —
rust/dialog-csv/README.md (source_commit a898b5de, 2 sections: overview, usage),
rust/dialog-remote-s3/README.md (a898b5de, 2 sections: overview, usage-walkthrough),
rust/dialog-remote-ucan-s3/README.md (a898b5de, 3 sections: overview,
usage-walkthrough, collaboration), rust/dialog-storage/README.md (source_commit
4ded84e3, dated 2025-12-12, 2 sections: storage-backends, r2-configuration). New
concept `content-addressed-storage-backend` (the pluggable Memory/FileSystem/
IndexedDb/S3 backend abstraction behind one content-addressed API). Concept rows
added to repository-branch-remote (the S3 + UCAN-S3 remotes), fact-triple (CSV
row format), ucan-delegation (the remote-layer collaboration walkthrough). Topics
touched: datalog-query, content-addressed-storage, local-first-sync,
ucan-authorization, capability-security, persistence.

Remaining (respect 3-5 sources / ~25 sections per cycle):

1. TypeScript cluster (one cycle) — the JS/browser API face of dialog-db. NOTE the
   remainder-11/12 estimate of a "package README" was WRONG: neither TS package has
   a README at this HEAD. The real sources are the doc-commented TS modules:
   - typescript/dialog-experimental/src/session.ts (526 lines, commit 03c82744):
     the substantial JS Session API — DID identifiers, the Changes/retraction model
     (a change retracting a set of facts for one relation), Task-based async, the
     fact/query surface bridging to @dialog-db/query and the wasm dialog_artifacts
     bindings. This is a full cycle on its own; split into sections by the module's
     doc-comment structure (session open, assert/retract changes, query, revisions/
     GENESIS). Topics: datalog-query, local-first-sync.
   - typescript/dialog-experimental/src/react.ts (77 lines, commit e9084657): the
     React bindings — DialogContext Provider, useSession, and a predicate hook that
     re-runs a query reactively. Topic: reactive-bindings, datalog-query.
   - SKIP typescript/dialog-experimental/src/lib.ts (4 lines, commit e9084657): a
     trivial re-export barrel over @dialog-db/query + ./session.js (confirmed stub
     2026-07-06).
   - typescript/dialog-experimental has NO package README and NO top-level README at
     this HEAD; ingest from the source modules directly (source-code-comment kind).
   - typescript/dialog-artifacts-web-tests: NO README — only bindings.test.ts +
     web-test-runner config (a browser test harness for the wasm artifact bindings).
     SKIP as a source unless bindings.test.ts is judged worth a short "how the JS
     artifact bindings are exercised" section; note the skip either way.
   Re-check the per-file commits at ingest.

2. Re-survey the rust crates that had NO README at the remainder-11 HEAD (still to
   confirm at this HEAD): dialog-blobs, dialog-credentials, dialog-encoding,
   dialog-macros, dialog-network, dialog-search-tree, dialog-ucan-core, dialog-varsig.
   Ingest any that have since gained a README; note those still bare.
   SKIP trivial stubs (confirmed still stubs through 2026-07-06): dialog-artifacts (3),
   dialog-common (0), dialog-dbsp (5), dialog-diagnose (0).

3. adr/ — still ONLY adr/000-template.md + adr/Readme.md at this HEAD; no populated
   decision records. DEFER until real ADRs land; note the skip.

Existing dialog-db topics: datalog-query, local-first-sync, ucan-authorization,
change-propagation, content-addressed-storage, capability-security. Existing concepts
include dialog-db, fact-triple, prolly-tree, merkle-crdt, schema-on-read,
ucan-delegation, record-value, formula-scheme, optional-attribute-query,
claim-projection, set-widening-type-system, demand-driven-incremental-maintenance,
divergence-clock, value-based-cas, profile-account-operator, signer-verifier-credential,
subject-routing, dialog-notation, deductive-rule, capability-chain, dialog-query-rust-api,
repository-branch-remote, content-addressed-storage-backend. Keep cross-referencing to
endo design material where concepts meet (ocap / capability-security, content-addressed /
durable storage, reactive-bindings, persistence). No fork or upstream actions.

Once the TypeScript cluster and the no-README re-survey are done and only the deferred
adr/ remains, this repo's active ingest backlog is EMPTY — post a light
scholar-library-refresh cadence check rather than another remainder-N job, unless new
sources have landed.
