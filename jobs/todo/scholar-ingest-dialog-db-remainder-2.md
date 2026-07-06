role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific
commit (`git log -1 main -- <path>`) still equals the recorded source_commit and
whose sections already exist.

Cycles so far:
- scholar-ingest-dialog-db (2026-07-06): 5 flagship docs — README,
  notes/architecture overview.md, notes/concept.md, notes/capability-sysstem.md,
  notes/privacy.md (22 sections). Topics: datalog-query, local-first-sync,
  ucan-authorization (+ reused capability-security, content-addressed-storage,
  change-propagation).
- scholar-ingest-dialog-db-remainder (2026-07-06): 4 docs — notes/sync.md (5),
  notes/version-control.md (6), notes/query-engine-design.md (5),
  notes/glossary.md (3, consolidated) = 19 sections. Topics touched:
  local-first-sync, change-propagation, datalog-query.

Remaining, in suggested priority order (respect 3-5 sources / ~25 sections per
cycle; post a further follow-on for whatever is left):

1. notes/ design corpus not yet ingested (~22 docs). High-signal first:
   planning-adornment-and-cost.md, query-cost-model.md, operator-ir.md, dbsp.md
   (+ notes/dbsp/findings.mds), rules.md, rule-pipeline.md,
   layered-rule-resolution.md, scope-and-delegation.md, space-and-storage.md.
   Then: divergence-clock.md, polarity-and-negation.md, record-value.md,
   optional-fields.md, formula.md, formula-schemes.md, scalar-associative-layer.md,
   incremental-subscriptions.md, refinements.md, repository.md, memory-layout.md,
   subject-routing-options.md, claim-based-serialization.md,
   causal-information-design-decision.md, guide.md. NOTE: notation.md is ~1713
   lines (query notation reference; + notes/notation/ subdir) — treat as its own
   full cycle. File rules/query-engine/planner/cost docs under datalog-query;
   divergence-clock/incremental-subscriptions under local-first-sync +
   change-propagation; scope-and-delegation/space-and-storage under
   ucan-authorization.

2. Rust crate docs: rust/dialog-repository/{README.md,Guide.md},
   rust/dialog-storage/README.md, rust/dialog-remote-s3/README.md,
   rust/dialog-remote-ucan-s3/README.md, rust/dialog-ucan/README.md, and the
   remaining crate READMEs (dialog-artifacts, dialog-search-tree, dialog-blobs,
   dialog-capability, dialog-common, dialog-encoding, dialog-query, dialog-dbsp,
   dialog-operator, dialog-network, dialog-effects, dialog-varsig, etc.).

3. TypeScript: typescript/dialog-experimental (src/lib.ts, session.ts, react.ts,
   package README) and typescript/dialog-artifacts-web-tests.

4. adr/ architectural decision records (adr/Readme.md + any populated records).

Keep cross-referencing to endo design material where concepts meet (ocap /
capability-security, content-addressed / durable storage, confinement,
persistence). No fork or upstream actions.
