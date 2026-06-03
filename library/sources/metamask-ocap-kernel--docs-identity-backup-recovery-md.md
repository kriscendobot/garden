---
source: docs/identity-backup-recovery.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/identity-backup-recovery.md
source_branch: main
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
source_date: (last touched in commit `a3eff0efb`)
source_authors: [MetaMask ocap-kernel team]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 164. **Fourth ocap-kernel ingest** (cycles 161 / 162 /
  163 / 164 form the §ocap-kernel-mini-series). §Queued-doc-3
  from cycle 161's plan.

  §Human-portable-cryptographic-identity-surface — 289 lines.
  Describes BIP39 mnemonic-based identity backup/recovery, a
  feature Endo does not yet have an analog for.

  §Identity-from-seed-not-from-storage foundational move:
  peer ID is *derived* from a cryptographic seed, not stored
  as an opaque blob. §Portability-equals-determinism-of-
  derivation. §Identity-recovery-equals-seed-recovery.

  §BIP39-mnemonic-as-identity-substrate: §human-readable-
  entropy-encoding; §twelve-or-twenty-four-words; §write-
  down-on-paper backup mechanism. §Standard-BIP39-compliance
  (PBKDF2-HMAC-SHA512 / 2048 iterations / empty passphrase) =
  §interoperability-with-other-BIP39-implementations both
  feature and §key-reuse-hazard.

  §One-way-derivation discipline: §mnemonicToSeed-is-
  irreversible. §Store-the-mnemonic-not-the-seed.
  §Opt-in-recoverability — pre-commit design discipline.
  §Random-seeds-cannot-be-mnemonicized-after-the-fact.

  §Four-scenario decomposition (§scenario-as-named-flow):
  1. Create recoverable identity (recommended)
  2. Random identity (no backup)
  3. Recover on new device
  4. Verify before migration

  §Scenario-4 is distinctively thoughtful: §dry-run-derive-
  without-init; §compare-with-known-good-identity. §The-
  utility-functions-are-pieces-not-just-private-
  implementation — users can compose mnemonicToSeed +
  generateKeyPairFromSeed + peerIdFromPrivateKey for
  verification outside the Kernel.make path.

  §Existing-identity-conflict-guard: §refuse-to-overwrite-
  existing-identity; §explicit-opt-in-via-resetStorage.
  §Error-message-is-actionable (*Cannot use mnemonic:
  kernel identity already exists. Use resetStorage to clear
  existing identity first.*). §Single-mistake-cannot-
  overwrite-identity.

  §Two-API-locations-for-mnemonic with §explicit-precedence-
  rule (initRemoteComms wins). §Last-write-wins; §avoid-
  silent-disagreement.

  §Six-security-best-practices (enumerated list): generate-
  first / never-log / clear-from-memory / secure-input /
  verify-before-recovery / store-securely. §Each-is-a-
  named-rule-not-vague-suggestion. §Principle-of-least-
  authority-applied-to-secrets-too (cycle 94's OCPL paper).

  §Identity-flows-through-the-stack: mnemonic →
  PBKDF2-HMAC-SHA512 → 32-byte seed → Ed25519 key pair →
  libp2p peer-id (multihash of public key) → discovery /
  dialing / ACL. §Identity-is-a-derivation-chain-not-a-
  stored-blob.

  §Gap-revealing-comparison with garden cycles: Endo
  daemons currently use Bewlay locator (path-like address);
  cycle 119's `dp` daemon-persistence covers formula
  persistence but not identity portability; cycle 141's
  daemon-cas-management uses SQLite storage but identity
  is still stored-blob. §Synthesis-target: Endo's daemon
  could borrow §identity-from-seed pattern for §user-
  portable-daemon-identity.

  §Tier-1 vocabulary borrowing candidates: §peer-id-from-
  seed; §mnemonic-as-portable-backup; §resetStorage-
  conflict-guard; §verify-before-recovery. §Tier-2: §opt-in-
  recoverability; §human-readable-entropy-encoding; §dry-
  run-derive-step.

  §Reference-with-runnable-examples doc genre observation —
  every API method has a code example; every scenario is
  end-to-end runnable; errors are shown as exact strings.
  Distinct from Endo's design-prose docs. §Synthesis-target
  for end-user-facing capability docs.

  Cycle 164 is comments-lane. Papers-lane blocked 58+
  consecutive cycles.
---

> Abstract: `docs/identity-backup-recovery.md` (289 lines) is
> the **§human-portable-cryptographic-identity-surface** doc.
> Describes ocap-kernel's BIP39 mnemonic-based identity
> backup/recovery — a feature Endo does not yet have an
> analog for.
>
> **Fourth ocap-kernel ingest** after cycles 161 / 162 / 163.
> §Queued-doc-3 from cycle 161's plan.
>
> §Identity-from-seed-not-from-storage foundational move:
> peer ID is *derived* from cryptographic seed, not stored
> blob. §BIP39-mnemonic as §human-portable-secret.
> §One-way-derivation discipline; §opt-in-recoverability;
> §random-seeds-cannot-be-mnemonicized-after-the-fact.
>
> §Four-scenario decomposition (§scenario-as-named-flow):
> Create recoverable / Random / Recover on new device /
> Verify before migration.
>
> §Scenario-4 is distinctively thoughtful: §dry-run-derive-
> without-init; §verify-before-recovery pattern.
>
> §Existing-identity-conflict-guard with §explicit-opt-in-
> via-resetStorage; §error-message-is-actionable.
> §Two-API-locations-with-explicit-precedence-rule.
>
> §Six-security-best-practices as named rules. §Standard-
> BIP39-test-vector-compatibility (interoperability and
> §key-reuse-hazard).
>
> §Identity-flows-through-the-stack: mnemonic → PBKDF2 →
> seed → Ed25519 keypair → libp2p peer-id.
>
> §Gap-revealing-comparison: Endo has no identity-recovery
> story. §Tier-1 vocabulary borrowing candidates: §peer-id-
> from-seed, §mnemonic-as-portable-backup, §resetStorage-
> conflict-guard, §verify-before-recovery.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard](../sections/metamask-ocap-kernel--docs-identity-backup-recovery-md--BIP39-mnemonic-identity-portability-with-verify-before-recovery-and-resetStorage-conflict-guard.md) | daemon, capability-security, persistence | current |

One cohesion-honest section. §Human-portable-cryptographic-
identity-surface as the unifying property.

## Provenance

- Fetched 2026-06-03 from `MetaMask/ocap-kernel@a3eff0efb`.
- License: dual Apache-2.0 + MIT.
- **Fourth ocap-kernel ingest** after cycles 161 / 162 / 163.
  §Queued-doc-3 from cycle 161's plan.
- Cycle 164 was nominally **comments-lane** (continuing the
  §ocap-kernel-mini-series). Papers-lane has been blocked
  for **58+ consecutive cycles**.
- One cohesion-honest section.
