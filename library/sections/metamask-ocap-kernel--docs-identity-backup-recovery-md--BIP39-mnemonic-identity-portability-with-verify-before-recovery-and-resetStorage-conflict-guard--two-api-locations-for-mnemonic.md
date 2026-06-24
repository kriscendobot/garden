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
title: §Two-API-locations-for-mnemonic
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

> *The `mnemonic` parameter can be passed either to
> `Kernel.make` (recommended) or to `initRemoteComms`.*
>
> *If mnemonic is provided in both places, the one in
> `initRemoteComms` takes precedence.*

§API-symmetry-with-precedence-rule. The recommended path is
Kernel.make; initRemoteComms is the §fallback-or-override.

§Why-two-locations: Kernel.make is the §earliest-bound; if
initRemoteComms is called later with a different mnemonic,
that's §explicit-intent-to-override (perhaps because the
mnemonic was loaded asynchronously from user input).

§Precedence-rule-is-explicit: §last-write-wins. §Avoid-
silent-disagreement — better to override than to fail
unpredictably.

§Cycle-156's-don't-design-yourself-into-a-corner stance
applies: providing §two-paths-with-explicit-resolution-rule
is better than §one-path-with-hidden-state.
