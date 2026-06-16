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
title: §Random-identity-cannot-be-mnemonicized-after-the-fact
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> *Random seeds cannot be converted to mnemonics. If you
> need backup capability, use Scenario 1 and generate a
> mnemonic first.*

§Pre-commit-design-discipline. §Opt-in-must-happen-at-
generation-time. §No-retrofitting-recoverability.

§Why-this-is-correct: BIP39 mnemonics encode entropy *plus
a checksum*; arbitrary 32-byte seeds will not have the
checksum bits in the right positions. Reverse-engineering a
mnemonic from a seed would require finding mnemonics whose
PBKDF2 output matches — computationally infeasible by
design (that's the same property that makes recovery sound:
the mapping is one-way).

§Documented-limitation-not-hidden-failure: the doc states
this explicitly, both inline (Scenario 2) and in the
§security-best-practices (§practice-1).
