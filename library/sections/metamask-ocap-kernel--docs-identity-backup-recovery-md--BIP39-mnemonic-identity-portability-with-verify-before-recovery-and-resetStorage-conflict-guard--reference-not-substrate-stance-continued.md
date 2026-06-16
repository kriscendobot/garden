---
source: docs/identity-backup-recovery.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/identity-backup-recovery.md
source_path: docs/identity-backup-recovery.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - persistence
genre: §sibling-implementation-comparison
cycle: 164
lane: comments
status: current
title: §Reference-not-substrate stance (continued)
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

§Vocabulary-borrowing-without-code-borrowing applies:
adopting the §identity-from-seed and §verify-before-recovery
patterns doesn't require importing BIP39 code. Endo could
choose its own derivation (Ed25519 from non-BIP39 sources,
or hash-based identifiers, etc.) and still adopt the
*structural* patterns.

§Citation-when-borrowing: a future Endo design adopting
§verify-before-recovery should cite this doc and §scenario-4.
