role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific
commit (`git log -1 main -- <path>`) still equals the recorded source_commit and
whose sections already exist.

Cycles so far:
- scholar-ingest-dialog-db (2026-07-06): 5 flagship docs (22 sections).
- scholar-ingest-dialog-db-remainder (2026-07-06): notes/sync.md, version-control.md,
  query-engine-design.md, glossary.md = 19 sections.
- scholar-ingest-dialog-db-remainder-2 (2026-07-06): query-planner/rules cluster,
  5 docs, 14 sections (rules.md, rule-pipeline.md, operator-ir.md, query-cost-model.md,
  planning-adornment-and-cost.md).
- scholar-ingest-dialog-db-remainder-3 (2026-07-06): rules/scope cluster, 5 docs,
  18 sections: layered-rule-resolution.md (5, datalog-query), scope-and-delegation.md
  (3, ucan-authorization), space-and-storage.md (3, ucan-authorization +
  content-addressed-storage), polarity-and-negation.md (3, datalog-query),
  refinements.md (4, datalog-query + change-propagation).

Remaining, in suggested priority order (respect 3-5 sources / ~25 sections per
cycle; post a further follow-on for whatever is left):

1. notes/ design corpus not yet ingested.
   - Data-model cluster (concept/attribute value model → datalog-query): record-value.md,
     optional-fields.md (~430 lines — large, may anchor a cycle), formula.md,
     formula-schemes.md, scalar-associative-layer.md, claim-based-serialization.md.
   - Incremental/causal cluster (local-first-sync + change-propagation): dbsp.md
     (+ notes/dbsp/findings.mds), divergence-clock.md, incremental-subscriptions.md,
     causal-information-design-decision.md.
   - Storage cluster (content-addressed-storage): repository.md, memory-layout.md,
     subject-routing-options.md.
   - Then guide.md (the longform end-to-end guide, ~17KB).
   - NOTE: notation.md is ~1713 lines (query notation reference; + notes/notation/
     subdir) — treat as its own full cycle.

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
  gardener: 12
  claimed_at: 2026-07-06T14:22:37Z
