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
- scholar-ingest-dialog-db-remainder-2 (2026-07-06): query-planner/rules cluster,
  5 docs, 14 sections.
- scholar-ingest-dialog-db-remainder-3 (2026-07-06): rules/scope cluster, 5 docs,
  18 sections.
- scholar-ingest-dialog-db-remainder-4 (2026-07-06): data-model cluster (partial),
  5 docs, 14 sections: record-value.md (3, datalog-query + content-addressed-storage),
  formula.md (2, datalog-query), formula-schemes.md (4, datalog-query),
  scalar-associative-layer.md (3, datalog-query), claim-based-serialization.md
  (2, ucan-authorization). New concept pages: record-value, formula-scheme,
  optional-attribute-query, claim-projection.

Remaining, in suggested priority order (respect 3-5 sources / ~25 sections per
cycle; post a further follow-on for whatever is left):

1. notes/ design corpus not yet ingested.
   - notes/optional-fields.md (~430 lines — the Option/Absent/Coalesce value-model
     half, deferred from cycle 4 to anchor its own cycle; datalog-query, pairs with
     the optional-attribute-query concept already written).
   - Incremental/causal cluster (local-first-sync + change-propagation): dbsp.md
     (+ notes/dbsp/findings.mds), divergence-clock.md, incremental-subscriptions.md,
     causal-information-design-decision.md.
   - Storage cluster (content-addressed-storage): repository.md, memory-layout.md,
     subject-routing-options.md.
   - Then guide.md (the longform end-to-end guide, ~17KB).
   - notes/architecture/ subdir (not yet surveyed).
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
change-propagation, content-addressed-storage. Keep cross-referencing to endo
design material where concepts meet (ocap / capability-security, content-addressed
/ durable storage, confinement, persistence). No fork or upstream actions.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 16
  claimed_at: 2026-07-06T14:40:50Z
