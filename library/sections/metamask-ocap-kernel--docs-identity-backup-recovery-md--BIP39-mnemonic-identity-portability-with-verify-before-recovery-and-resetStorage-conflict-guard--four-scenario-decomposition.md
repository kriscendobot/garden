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
title: §Four-scenario decomposition
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

The doc's structural move: §four-scenarios-cover-the-
state-space.

| Scenario | First-time mnemonic? | Has identity? | API call |
|----------|---------------------|---------------|----------|
| 1: Create recoverable | yes | no | Kernel.make({mnemonic}) |
| 2: Random (no backup) | no | no | Kernel.make({}) |
| 3: Recover on new device | yes (existing) | no (fresh) | Kernel.make({mnemonic, resetStorage: true}) |
| 4: Verify before migration | yes (existing) | irrelevant | derive peer-id without init |

§Scenario-as-named-flow discipline. Each scenario is a
*complete code example*, not a fragment. §Concrete-runnable-
patterns-not-abstract-rules.

§Scenario-4-is-distinctively-thoughtful: it lets you
§verify-the-mnemonic-produces-expected-peer-ID-before-
trusting-it. This is §dry-run-before-commit discipline —
useful when the cost of getting recovery wrong is
high (you'd be initializing with the wrong identity and
discovering it after publishing it to peers).
