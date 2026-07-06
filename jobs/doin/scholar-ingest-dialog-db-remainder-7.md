role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific
commit (`git log -1 main -- <path>`) still equals the recorded source_commit and
whose sections already exist. A scratch clone is at scratch/dialog-db-src (fetch
main before reading).

Cycles so far:
- scholar-ingest-dialog-db (2026-07-06): 5 flagship docs (22 sections).
- scholar-ingest-dialog-db-remainder (2026-07-06): sync.md, version-control.md,
  query-engine-design.md, glossary.md = 19 sections.
- scholar-ingest-dialog-db-remainder-2: query-planner/rules cluster, 5 docs, 14 sections.
- scholar-ingest-dialog-db-remainder-3: rules/scope cluster, 5 docs, 18 sections.
- scholar-ingest-dialog-db-remainder-4: data-model cluster (partial), 5 docs, 14 sections.
- scholar-ingest-dialog-db-remainder-5: optional-fields.md + incremental/causal cluster, 21 sections.
- scholar-ingest-dialog-db-remainder-6 (2026-07-06): notes/ STORAGE cluster:
  repository.md (5), memory-layout.md (2), subject-routing-options.md (1) = 8 sections.
  space-and-storage.md SKIPPED (idempotent, commit 18c640a0 unchanged, 3 sections exist).
  New concept pages: profile-account-operator, signer-verifier-credential, subject-routing.

Remaining, in suggested priority order (respect 3-5 sources / ~25 sections per
cycle; post a further follow-on for whatever is left):

1. notes/ design corpus not yet ingested.
   - guide.md ("Optionality in the query engine", ~407 lines / 13 headings; the
     longform end-to-end query-optionality guide, companion to optional-fields.md;
     files under datalog-query + optional-fields, NOT storage — its own coherent
     cycle, ~8-10 sections).
   - notes/architecture/ subdir (not yet surveyed).
   - notes/dbsp/findings.mds (the DBSP findings companion to the already-ingested dbsp.md).
   - NOTE: notation.md is ~1713 lines (query notation reference; + notes/notation/
     subdir) -- treat as its own full cycle.

2. Rust crate docs: rust/dialog-repository/{README.md,Guide.md},
   rust/dialog-storage/README.md, rust/dialog-remote-s3/README.md,
   rust/dialog-remote-ucan-s3/README.md, rust/dialog-ucan/README.md, and the
   remaining crate READMEs (dialog-artifacts, dialog-search-tree, dialog-blobs,
   dialog-capability, dialog-common, dialog-encoding, dialog-query, dialog-dbsp,
   dialog-operator, dialog-network, dialog-effects, dialog-varsig,
   dialog-credentials, dialog-csv, dialog-diagnose, dialog-macros, dialog-ucan-core).

3. TypeScript: typescript/dialog-experimental (src/lib.ts, session.ts, react.ts,
   package README) and typescript/dialog-artifacts-web-tests.

4. adr/ architectural decision records (adr/Readme.md + any populated records;
   currently only 000-template.md and Readme.md present).

Existing dialog-db topics: datalog-query, local-first-sync, ucan-authorization,
change-propagation, content-addressed-storage. Existing dialog-db concepts include
dialog-db, fact-triple, prolly-tree, merkle-crdt, schema-on-read, ucan-delegation,
record-value, formula-scheme, optional-attribute-query, claim-projection,
set-widening-type-system, demand-driven-incremental-maintenance, divergence-clock,
value-based-cas, profile-account-operator, signer-verifier-credential,
subject-routing. Keep cross-referencing to endo design material where concepts
meet (ocap / capability-security, content-addressed / durable storage,
confinement, persistence). No fork or upstream actions.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 9
  claimed_at: 2026-07-06T15:19:48Z
