role: scholar

Continue ingesting https://github.com/dialog-db/dialog-db into journal/library/
(cross-cutting reference), per roles/scholar/AGENT.md. Repo default branch `main`,
HEAD f777fe7c (2026-07-05). Idempotency: skip any source whose file-specific commit
(`git log -1 main -- <path>`) still equals the recorded source_commit and whose
sections already exist. Scratch clone at scratch/dialog-db-src (fetch main first).

The notes/ prose corpus is now FULLY ingested. As of remainder-8 (2026-07-06,
commit landed): notes/notation.md → 12 sections (overview, structural-identity,
selectors-domains-and-names, attribute, concept, deductive-rules,
constraints-and-formulas, assertions-and-claims, and the four abbreviated-*),
plus its companion notes/notation/schema.json → 1 section
(dialog-db--notes-notation-schema--json-schema). New concepts dialog-notation and
deductive-rule; fact-triple + keywords cross-referenced.

Remaining (respect 3-5 sources / ~25 sections per cycle; post a further follow-on
for whatever is left):

1. notes/dbsp/findings.mds (~9KB) — the DBSP findings companion to the already-
   ingested notes/dbsp.md; ties to demand-driven-incremental-maintenance /
   change-propagation. Small; can share a cycle with the smaller Rust crate docs.

2. Rust crate docs (topic: content-addressed-storage / ucan-authorization / new
   crate topics as needed). Substantial ones, largest first:
   rust/dialog-query/README.md (316), rust/dialog-repository/Guide.md (273) +
   README.md (98), rust/dialog-capability/README.md (103), rust/dialog-effects/
   README.md (79), rust/dialog-csv/README.md (60), rust/dialog-remote-s3/README.md
   (55), rust/dialog-remote-ucan-s3/README.md (51), rust/dialog-storage/README.md
   (37), rust/dialog-operator/README.md (34), rust/dialog-ucan/README.md (34).
   SKIP the empty/trivial stubs (dialog-common 0, dialog-diagnose 0,
   dialog-artifacts 3, dialog-dbsp 5 lines) unless they gain content — note them
   skipped. Re-survey the crates that had no README at this HEAD (dialog-blobs,
   dialog-credentials, dialog-encoding, dialog-macros, dialog-network,
   dialog-search-tree, dialog-varsig, dialog-ucan-core). Given the volume, the
   Rust crates likely span 2-3 cycles: dialog-query README is a full cycle on its
   own; dialog-repository (Guide+README) another; the rest one more.

3. TypeScript: typescript/dialog-experimental (src/lib.ts, session.ts, react.ts,
   package README) and typescript/dialog-artifacts-web-tests.

4. adr/ — currently ONLY adr/000-template.md (355 bytes) + adr/Readme.md (365
   bytes); no populated decision records exist yet. DEFER until real ADRs land;
   note the skip.

Existing dialog-db topics: datalog-query, local-first-sync, ucan-authorization,
change-propagation, content-addressed-storage. Existing concepts include dialog-db,
fact-triple, prolly-tree, merkle-crdt, schema-on-read, ucan-delegation, record-value,
formula-scheme, optional-attribute-query, claim-projection, set-widening-type-system,
demand-driven-incremental-maintenance, divergence-clock, value-based-cas,
profile-account-operator, signer-verifier-credential, subject-routing, dialog-notation,
deductive-rule. Keep cross-referencing to endo design material where concepts meet
(ocap / capability-security, content-addressed / durable storage, confinement,
persistence). No fork or upstream actions.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 9
  claimed_at: 2026-07-06T15:46:54Z
