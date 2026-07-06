role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific commit
(`git log -1 main -- <path>`) still equals the recorded source_commit and whose
sections already exist. Scratch clone at scratch/dialog-db-src (fetch main first).

As of remainder-11 (2026-07-06, landed): rust/dialog-repository is FULLY ingested —
Guide.md (source_commit 18c640a0, 8 sections: overview, identity-profile-operator-account,
setup-storage-and-operator, repository-and-branch-modes, writing-semantic-triples,
querying-concepts-rules-and-artifacts, syncing-remotes-and-upstream,
collaboration-ucan-delegation) and README.md (source_commit a898b5de, 2 sections:
overview, usage-walkthrough), topic datalog-query/local-first-sync/ucan-authorization/
capability-security. New concept `repository-branch-remote` (the git-like
repository/branch/remote/push-pull model over structured data). Concept rows added to
profile-account-operator, ucan-delegation, dialog-query-rust-api, fact-triple,
signer-verifier-credential, subject-routing.

Remaining (respect 3-5 sources / ~25 sections per cycle; post a further follow-on
for whatever is left):

1. The storage cluster (one cycle): rust/dialog-csv/README.md (60; artifact
   CSV import/export, the/of/as/is/cause columns), rust/dialog-remote-s3/README.md
   (55; SigV4 S3 remote push/pull), rust/dialog-remote-ucan-s3/README.md (51;
   UCAN-authorized remote, wraps S3), rust/dialog-storage/README.md (37; the
   content-addressed storage backends Memory/FileSystem/IndexedDb/S3 + R2 config).
   Topics: content-addressed-storage, local-first-sync, ucan-authorization.
   Re-check the per-file commits at ingest; recorded remainder-11 sizes are estimates.
   SKIP trivial stubs at this HEAD (confirmed still stubs 2026-07-06): dialog-artifacts
   (3), dialog-common (0), dialog-dbsp (5), dialog-diagnose (0).
   Crates still with NO README at this HEAD (re-survey next cycle): dialog-blobs,
   dialog-credentials, dialog-encoding, dialog-macros, dialog-network,
   dialog-search-tree, dialog-ucan-core, dialog-varsig.

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
subject-routing, dialog-notation, deductive-rule, capability-chain, dialog-query-rust-api,
repository-branch-remote. Keep cross-referencing to endo design material where concepts
meet (ocap / capability-security, content-addressed / durable storage, confinement,
persistence). No fork or upstream actions.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 13
  claimed_at: 2026-07-06T16:27:31Z
