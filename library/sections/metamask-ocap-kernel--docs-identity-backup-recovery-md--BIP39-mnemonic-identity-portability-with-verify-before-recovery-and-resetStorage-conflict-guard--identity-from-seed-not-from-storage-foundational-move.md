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
title: §Identity-from-seed-not-from-storage (foundational move)
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> *Each kernel has a unique identity derived from a
> cryptographic seed. This identity determines the kernel's
> peer ID.*

§Identity-is-derived-from-seed — the kernel's peer ID is a
*function* of its seed, not a stored opaque blob. This is
the load-bearing observation: §identity-recovery-equals-
seed-recovery; §portability-equals-determinism-of-derivation.

§Cycle-141-daemon-cas-management used SQLite as the storage
substrate for the daemon; cycle 119's `dp` daemon-
persistence design separates orthogonal vs manual
persistence. Neither addresses §identity-portability-
across-devices. Endo's current Bewlay locator is a
*path-like address* — not derivable from a recoverable
secret.

§Synthesis-target: Endo's daemon could borrow the §identity-
from-seed pattern for §user-portable-daemon-identity.
