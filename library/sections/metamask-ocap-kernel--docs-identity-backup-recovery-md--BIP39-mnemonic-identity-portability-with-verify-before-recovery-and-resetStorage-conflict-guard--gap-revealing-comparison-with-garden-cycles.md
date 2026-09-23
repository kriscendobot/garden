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
title: §Gap-revealing-comparison with garden cycles
parent: metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard
---

### §Synthesis-targets identified

| Glossary term | Endo gap |
|---------------|----------|
| §Identity-from-seed-not-from-storage | Endo's Bewlay locator is path-like; no seed-based portable identity |
| §BIP39-mnemonic-as-human-portable-secret | No analog in Endo |
| §Verify-before-recovery pattern (Scenario 4) | No standard §dry-run-derive-then-commit shape |
| §Existing-identity-conflict-guard | Cycle 119's `dp` doesn't yet name this invariant |
| §Two-API-locations-with-explicit-precedence | Could clean up Endo's locator-vs-config tension |
| §Opt-in-recoverability-at-generation-time | Endo's daemon could borrow as §pre-commit-design discipline |

### §Vocabulary-borrowing candidates

**Tier-1**: §peer-id-from-seed; §mnemonic-as-portable-backup;
§resetStorage-conflict-guard; §verify-before-recovery.

**Tier-2**: §opt-in-recoverability; §human-readable-entropy-
encoding; §dry-run-derive-step.

§Citation-discipline-when-borrowing-still-applies: any Endo
design adopting BIP39 vocabulary should §cite-ocap-kernel-
and-BIP39.
