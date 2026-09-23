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
title: §Existing-identity-conflict-guard (defensive design)
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> *If the kernel already has a stored identity and you
> provide a mnemonic, an error is thrown to prevent
> accidentally using the wrong identity.*

§Refuse-to-overwrite-existing-identity discipline. §Explicit-
opt-in-via-resetStorage discriminates §recovery-intent from
§accidental-mnemonic-passed-twice.

§Error-message-is-actionable:

> *Cannot use mnemonic: kernel identity already exists. Use
> resetStorage to clear existing identity first.*

§Error-tells-you-the-fix discipline. §Cycle-149's-error-
path-cannot-depend-on-error-path is a different invariant
but the spirit is similar: §error-message-as-recovery-aid;
§make-the-error-the-documentation.

§Two-step-explicit-confirmation: the user must (a) pass
the mnemonic AND (b) opt into resetStorage. §Single-
mistake-cannot-overwrite-identity.
