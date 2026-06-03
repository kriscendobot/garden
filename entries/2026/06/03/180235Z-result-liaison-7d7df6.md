---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--7d7df6
ts: 2026-06-03T18:02:35Z
ref_id: 7d7df6
---

# Cycle 164: ocap-kernel docs/identity-backup-recovery.md (fourth ocap-kernel ingest; human-portable cryptographic identity)

Cycle 164 continues the §ocap-kernel-mini-series (cycles
161 / 162 / 163 / 164). §Queued-doc-3 from cycle 161's
plan: `docs/identity-backup-recovery.md` (289 lines).

This doc describes a feature **Endo does not yet have an
analog for**: BIP39 mnemonic-based identity backup and
recovery. The §identity-from-seed-not-from-storage move
is structurally important — it shifts identity from a
*stored blob* to a *derivation chain*, with implications
for cycle 119's `dp` daemon-persistence design and cycle
141's daemon-cas-management.

## Source

`MetaMask/ocap-kernel docs/identity-backup-recovery.md`
from the bare clone at `/home/kris/garden/worktrees/
metamask-ocap-kernel.git/`. HEAD `a3eff0efb` 2026-05-28;
file last-touched in same commit. 289 lines. Dual
Apache-2.0 + MIT.

## Sections written (1)

`metamask-ocap-kernel--docs-identity-backup-recovery-md--
BIP39-mnemonic-identity-portability-with-verify-before-
recovery-and-resetStorage-conflict-guard.md` (353 lines;
commit `e78cc5ee`).

**§Cohesion-honest section count**: One section. §The-
identity-backup-recovery-surface-is-one-vocabulary; splitting
would fragment the §identity-flows-through-the-stack
observation across multiple files.

## Why this ingest matters

The maintainer's original directive (between cycles 161/
162) named ocap-kernel as a comparison substrate for
*our slot machine and OCapN*. Identity-portability is one
of the most directly comparable surfaces:

- **Endo's daemon** has identity-as-stored-blob (Bewlay
  locator).
- **Slot machine work** depends on identity being
  *portable* (a user must be able to use their slot
  identity across devices).
- **OCapN** is the protocol layer; identity portability
  *under* OCapN is an open question.

This doc supplies a worked answer: derive identity from a
human-readable secret (BIP39 mnemonic), make derivation
deterministic, store *the mnemonic* not the seed.

## Structural moves captured

- **§Identity-from-seed-not-from-storage**: foundational
  move. §Portability-equals-determinism-of-derivation.
  §Identity-recovery-equals-seed-recovery.
- **§BIP39-mnemonic-as-identity-substrate**: §human-
  readable-entropy-encoding; §write-down-on-paper; §five-
  supported-lengths (12/15/18/21/24 words; 128-256 bits).
- **§Standard-BIP39-compliance**: PBKDF2-HMAC-SHA512 /
  2048 iterations / empty passphrase. §Interoperability-
  as-design-axiom and §key-reuse-hazard.
- **§One-way-derivation-discipline**: §mnemonicToSeed-is-
  irreversible; §store-the-mnemonic-not-the-seed.
- **§Opt-in-recoverability**: pre-commit-design discipline;
  §random-seeds-cannot-be-mnemonicized-after-the-fact.
- **§Four-scenario decomposition** (§scenario-as-named-flow):
  Create recoverable / Random / Recover / Verify.
  §Scenario-4 is §distinctively-thoughtful — §dry-run-
  derive-without-init + §compare-with-known-good-identity.
- **§Existing-identity-conflict-guard**: §refuse-to-
  overwrite-existing-identity; §explicit-opt-in-via-
  resetStorage; §error-message-is-actionable; §single-
  mistake-cannot-overwrite-identity.
- **§Two-API-locations-with-explicit-precedence-rule**:
  Kernel.make recommended; initRemoteComms wins on
  collision. §Last-write-wins; §avoid-silent-disagreement.
- **§Six-security-best-practices** as named rules.
  §Principle-of-least-authority-applied-to-secrets-too
  (cycle 94 OCPL).
- **§Identity-flows-through-the-stack**: mnemonic →
  PBKDF2-HMAC-SHA512 → 32-byte seed → Ed25519 keypair →
  libp2p peer-id. §Identity-is-a-derivation-chain-not-a-
  stored-blob.

## §Gap-revealing-comparison with garden cycles

| Cycle | Endo gap |
|-------|----------|
| 119 (`dp` daemon-persistence) | Covers formula persistence but assumes identity is a stored object |
| 141 (daemon-cas-management) | Uses SQLite for storage but identity is still a stored blob |
| Bewlay locator | Path-like address; not derivable from human-portable secret |
| Slot machine work | Needs portable identity across devices — direct beneficiary |

§Synthesis-target: Endo's daemon could borrow §identity-
from-seed pattern for §user-portable-daemon-identity
*without* changing what the daemon does internally —
the shift is in *how identity is stored and recovered*.

## §Tier-1 vocabulary borrowing candidates

§peer-id-from-seed, §mnemonic-as-portable-backup,
§resetStorage-conflict-guard, §verify-before-recovery.

§Tier-2: §opt-in-recoverability, §human-readable-entropy-
encoding, §dry-run-derive-step.

§Citation-discipline applies: any Endo design adopting
BIP39 vocabulary should cite this doc.

## §Reference-with-runnable-examples doc genre

Distinct from Endo's design-prose docs (cycles 117-119).
§Every-API-method-has-a-code-example; §every-scenario-is-
end-to-end-runnable; §errors-shown-as-exact-strings.
§Synthesis-target: §reference-with-runnable-examples is a
useful complement to design-prose for end-user-facing
capabilities. The slot machine library's identity-recovery
docs (if/when they exist) should follow this genre.

## Files written / edited

- `library/sections/metamask-ocap-kernel--docs-identity-
  backup-recovery-md--BIP39-mnemonic-identity-portability-
  with-verify-before-recovery-and-resetStorage-conflict-
  guard.md` (353 lines; commit `e78cc5ee`)
- `library/sources/metamask-ocap-kernel--docs-identity-
  backup-recovery-md.md` (new source page)
- `library/sources/README.md` (cycle-164 row added under
  "External code repositories (sibling implementations)"
  above cycle-163 glossary row)
- `library/sections/README.md` (cycle-164 entry; totals
  bumped 668/209 → 669/210)
- `library/topics/daemon.md` (cycle-164 row)
- `library/topics/capability-security.md` (cycle-164 row)
- `library/topics/persistence.md` (cycle-164 row;
  §identity-as-a-derivation-chain-not-a-stored-blob is the
  persistence-relevant move)
- `library/keywords.md` (67 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

668 / 209 → **669 sections from 210 source documents**.

## Lane rotation note

Cycle 164 was nominally papers-lane in the rotation;
papers-lane has been blocked **58+ consecutive cycles**.
Pivoted gracefully to comments-lane and continued the
ocap-kernel queue.

The §ocap-kernel-mini-series now spans four cycles:
- Cycle 161: monorepo overview (user-directed; off-rotation)
- Cycle 162: ken-protocol-assessment.md
- Cycle 163: glossary.md
- Cycle 164: identity-backup-recovery.md

Remaining §queued-doc items from cycle 161's plan:
kernel-guide.md, platform-specific.md, usage.md.

## Cycle 164 — done. Schedule cycle 165.
