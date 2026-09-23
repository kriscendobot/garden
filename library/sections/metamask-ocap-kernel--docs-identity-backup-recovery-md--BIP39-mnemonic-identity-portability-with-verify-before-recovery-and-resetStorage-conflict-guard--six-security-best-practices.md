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
title: §Six security best practices
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> 1. Generate mnemonic first
> 2. Never log or transmit mnemonics
> 3. Clear mnemonic from memory
> 4. Use secure input methods
> 5. Verify before recovery
> 6. Store backups securely

§Best-practices-as-enumerated-list. §Each-is-a-named-rule
not-a-vague-suggestion.

§Practice-1 is the §opt-in-recoverability bottleneck;
§practice-2 is §don't-leak-the-secret through logs or
network; §practice-3 is §minimize-memory-residency
(prevent in-memory snooping); §practice-4 is §don't-touch-
the-clipboard (avoid clipboard-readers); §practice-5 is
§Scenario-4; §practice-6 is §write-it-down-not-cloud-
store (avoid §digital-backup-as-attack-surface).

§Cycle-94's-OCPL paper §principle-of-least-authority-
applied-to-secrets-too: each practice reduces the §authority-
the-mnemonic-confers-to-attackers.
