role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. The first pass
(scholar-ingest-dialog-db, 2026-07-06) filed 5 flagship design docs at repo HEAD
f777fe7c: README, notes/architecture overview.md, notes/concept.md,
notes/capability-sysstem.md, notes/privacy.md (22 sections; new topics
datalog-query, local-first-sync, ucan-authorization; reused capability-security,
content-addressed-storage, change-propagation). Idempotency: skip any source
whose file-specific commit still equals f777fe7c and whose sections already exist.

Remaining, in suggested priority order (respect the 3-5 sources / ~25 section
budget per cycle; post a further follow-on for whatever is left):

1. notes/ design corpus not yet ingested (~26 docs). High-signal first:
   sync.md, version-control.md, glossary.md, query-engine-design.md,
   planning-adornment-and-cost.md, query-cost-model.md, operator-ir.md, dbsp.md
   (+ notes/dbsp/findings.mds), rules.md, rule-pipeline.md,
   layered-rule-resolution.md, scope-and-delegation.md, space-and-storage.md.
   Then: divergence-clock.md, polarity-and-negation.md, record-value.md,
   optional-fields.md, formula.md, formula-schemes.md, scalar-associative-layer.md,
   incremental-subscriptions.md, refinements.md, repository.md, memory-layout.md,
   subject-routing-options.md, claim-based-serialization.md,
   causal-information-design-decision.md, guide.md. NOTE: notation.md is ~1713
   lines (the query notation reference) — treat as its own full cycle.
   File rules/query-engine docs under datalog-query; sync/version-control/
   divergence-clock under local-first-sync + change-propagation;
   scope-and-delegation/space-and-storage under ucan-authorization.

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
