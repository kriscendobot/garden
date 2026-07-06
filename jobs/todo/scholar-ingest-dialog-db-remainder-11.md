role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific commit
(`git log -1 main -- <path>`) still equals the recorded source_commit and whose
sections already exist. Scratch clone at scratch/dialog-db-src (fetch main first).

As of remainder-10 (2026-07-06, landed): rust/dialog-query/README.md is FULLY
ingested — 7 sections (overview, associative-claims, associative-relations,
semantic-attributes, semantic-concepts, deductive-rules, formulas) under topic
datalog-query, source_commit ebd8f739, plus new concept `dialog-query-rust-api`
(the crate's Rust derive-macro + Session/Query API surface). Concept rows added to
fact-triple, dialog-notation, schema-on-read, deductive-rule, formula-scheme.

Remaining (respect 3-5 sources / ~25 sections per cycle; post a further follow-on
for whatever is left):

1. Rust crate docs:
   - rust/dialog-repository/Guide.md (273) + rust/dialog-repository/README.md (98)
     — a full cycle together; the repository/branch/remote model. Topics:
     local-first-sync, content-addressed-storage (and new topics as needed).
   - The storage cluster (one cycle): rust/dialog-csv/README.md (60; artifact
     CSV import/export, the/of/as/is/cause columns), rust/dialog-remote-s3/README.md
     (55; SigV4 S3 remote push/pull), rust/dialog-remote-ucan-s3/README.md (51;
     UCAN-authorized remote, wraps S3), rust/dialog-storage/README.md (37; the
     content-addressed storage backends Memory/FileSystem/IndexedDb/S3 + R2 config).
     Topics: content-addressed-storage, local-first-sync, ucan-authorization.
   SKIP trivial stubs at this HEAD (confirmed still stubs 2026-07-06): dialog-artifacts
   (3), dialog-common (0), dialog-dbsp (5), dialog-diagnose (0).
   Crates still with NO README at this HEAD (confirmed absent 2026-07-06, re-survey
   next cycle): dialog-blobs, dialog-credentials, dialog-encoding, dialog-macros,
   dialog-network, dialog-search-tree, dialog-ucan-core, dialog-varsig.

2. TypeScript: typescript/dialog-experimental (src/lib.ts, session.ts, react.ts,
   package README) and typescript/dialog-artifacts-web-tests.

3. adr/ — still ONLY adr/000-template.md + adr/Readme.md; no populated decision
   records. DEFER until real ADRs land; note the skip.

Existing dialog-db topics: datalog-query, local-first-sync, ucan-authorization,
change-propagation, content-addressed-storage, capability-security. Existing concepts
include dialog-db, fact-triple, prolly-tree, merkle-crdt, schema-on-read,
ucan-delegation, record-value, formula-scheme, optional-attribute-query,
claim-projection, set-widening-type-system, demand-driven-incremental-maintenance,
divergence-clock, value-based-cas, profile-account-operator, signer-verifier-credential,
subject-routing, dialog-notation, deductive-rule, capability-chain, dialog-query-rust-api.
Keep cross-referencing to endo design material where concepts meet (ocap /
capability-security, content-addressed / durable storage, confinement, persistence).
No fork or upstream actions.
