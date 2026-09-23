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
title: §One-way-derivation discipline
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> *This is a **one-way operation** - you cannot reverse a
> seed back to its mnemonic. To enable backup/recovery,
> store the original mnemonic.*

§mnemonicToSeed-is-irreversible. §Store-the-mnemonic-not-
the-seed advice. §Random-seeds-cannot-be-converted-to-
mnemonics (Scenario 2 footnote): if no mnemonic was used
at first init, *no* mnemonic can be reverse-engineered
later.

§Opt-in-recoverability discipline: the user must choose
backup *before* generating identity. The §generate-mnemonic-
first pattern (Scenario 1) is named as §recommended.

§Cycle-100-GC-rejection-tracker hazard parallel: §state-
that-cannot-be-recovered-after-the-fact requires §pre-
commit-discipline. Both cases punish §retrofitting and
reward §up-front-design.
