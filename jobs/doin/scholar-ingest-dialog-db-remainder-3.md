role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific
commit (`git log -1 main -- <path>`) still equals the recorded source_commit and
whose sections already exist.

Cycles so far:
- scholar-ingest-dialog-db (2026-07-06): 5 flagship docs (22 sections). Topics:
  datalog-query, local-first-sync, ucan-authorization.
- scholar-ingest-dialog-db-remainder (2026-07-06): notes/sync.md, version-control.md,
  query-engine-design.md, glossary.md = 19 sections.
- scholar-ingest-dialog-db-remainder-2 (2026-07-06): the query-planner/rules cluster,
  5 docs, 14 sections, all datalog-query (+ change-propagation on 3):
  notes/rules.md (2), notes/rule-pipeline.md (2), notes/operator-ir.md (3),
  notes/query-cost-model.md (3), notes/planning-adornment-and-cost.md (4).

Remaining, in suggested priority order (respect 3-5 sources / ~25 sections per
cycle; post a further follow-on for whatever is left):

1. notes/ design corpus not yet ingested. Rules/scope cluster (file under
   datalog-query, scope/space under ucan-authorization): layered-rule-resolution.md,
   scope-and-delegation.md, space-and-storage.md, polarity-and-negation.md,
   refinements.md, rule-pipeline (done). Data-model cluster: record-value.md,
   optional-fields.md, formula.md, formula-schemes.md, scalar-associative-layer.md,
   claim-based-serialization.md. Incremental/causal cluster (local-first-sync +
   change-propagation): dbsp.md (+ notes/dbsp/findings.mds), divergence-clock.md,
   incremental-subscriptions.md, causal-information-design-decision.md. Storage:
   repository.md, memory-layout.md, subject-routing-options.md. Then guide.md
   (the longform end-to-end guide, ~17KB). NOTE: notation.md is ~1713 lines
   (query notation reference; + notes/notation/ subdir) — treat as its own full cycle.

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

Keep cross-referencing to endo design material where concepts meet (ocap /
capability-security, content-addressed / durable storage, confinement,
persistence). No fork or upstream actions.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 17
  claimed_at: 2026-07-06T14:07:22Z
