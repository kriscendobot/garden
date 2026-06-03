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
---

# BIP39 mnemonic identity portability with verify-before-recovery and resetStorage conflict guard

> §Sibling-implementation-comparison genre (fourth ingest;
> §ocap-kernel-mini-series cycles 161/162/163/164).
> §Queued-doc-3 from cycle 161's overview's plan.

`docs/identity-backup-recovery.md` (289 lines) is the
**§human-portable-cryptographic-identity-surface** doc. It
describes ocap-kernel's BIP39 mnemonic-based identity
backup and recovery story — a feature Endo does not yet
have an analog for. The doc covers the four scenarios
(create / random / recover / verify), the API surface
(generateMnemonic / isValidMnemonic / mnemonicToSeed +
Kernel.make options), and the operational disciplines
around it (§existing-identity-conflict-guard, §verify-
before-recovery, six §security-best-practices).

## §Identity-from-seed-not-from-storage (foundational move)

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

## §BIP39-mnemonic-as-identity-substrate

> *A BIP39 mnemonic is a human-readable sequence of words
> (typically 12 or 24 words) that represents cryptographic
> entropy.*

§Human-readable-entropy-encoding is the §primary-affordance.
§Twelve-or-twenty-four-words; §write-down-on-paper as the
backup mechanism.

§Standard-BIP39-compliance: §PBKDF2-HMAC-SHA512 / §2048-
iterations / §empty-passphrase / §standard-BIP39-test-
vector-compatibility. §Interoperability-with-other-BIP39-
implementations is a deliberate design choice — the same
mnemonic can be used in other wallets and tools (which is
both a feature for portability and a §threat-surface for
key-reuse).

§Five-supported-lengths: 12, 15, 18, 21, 24 words. §128-256-
bits-of-entropy range. The doc only exposes 12 or 24 in
the generator API — §sensible-defaults-not-all-options.

## §One-way-derivation discipline

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

## §Four-scenario decomposition

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

## §Existing-identity-conflict-guard (defensive design)

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

## §verify-before-recovery — Scenario 4's load-bearing pattern

```typescript
async function getPeerIdFromMnemonic(mnemonic: string): Promise<string> {
  if (!isValidMnemonic(mnemonic)) {
    throw new Error('Invalid mnemonic');
  }

  const seed = mnemonicToSeed(mnemonic);
  const keyPair = await generateKeyPairFromSeed('Ed25519', fromHex(seed));
  return peerIdFromPrivateKey(keyPair).toString();
}

const recoveredPeerId = await getPeerIdFromMnemonic(recoveryMnemonic);
if (recoveredPeerId === expectedPeerId) {
  console.log('Mnemonic verified! Safe to proceed with recovery.');
} else {
  console.log('Warning: This mnemonic produces a different peer ID.');
}
```

§Dry-run-derive-without-init. §Compare-with-known-good-
identity. §Don't-trust-user-input-blindly even after
isValidMnemonic.

§The-side-quest-shape: the doc shows the user how to
*compose* the public utility functions (mnemonicToSeed +
generateKeyPairFromSeed + peerIdFromPrivateKey) to perform
verification *outside* the Kernel.make path. §The-utility-
functions-are-pieces-not-just-private-implementation.

§Synthesis-target: §verify-derivation-before-commit-pattern
generalizes beyond mnemonics. Any derivation-based identity
system benefits from §dry-run-derive-step.

## §Two-API-locations-for-mnemonic

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

## §Six security best practices

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

## §Standard-BIP39-test-vector-compatibility

> *This implementation uses standard BIP39 PBKDF2-HMAC-SHA512
> derivation (2048 iterations) with an empty passphrase.
> This ensures compatibility with standard BIP39 test
> vectors and other implementations.*

§Don't-invent-your-own-crypto. §Use-standard-test-vectors.
§Empty-passphrase-is-the-default-BIP39 (some implementations
allow an additional passphrase as a §two-factor-secret;
ocap-kernel deliberately doesn't).

§Trade-off-named: empty passphrase = standard portability
but no §passphrase-as-deniable-second-factor. The doc
doesn't argue for the choice; it just states it.

§Interoperability-as-design-axiom: a mnemonic generated in
ocap-kernel works in any BIP39-compliant tool. This is
both a §portability-win and a §key-reuse-hazard (a user
might use the same mnemonic for their wallet and their
kernel identity; compromise of either compromises both).

## §Random-identity-cannot-be-mnemonicized-after-the-fact

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

## §Gap-revealing-comparison with garden cycles

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

## §Wider context — peer-ID-based discovery

§libp2p-peer-id is the §network-layer-identifier this whole
mechanism produces. Cycle 161's overview noted ocap-kernel
uses libp2p for transport; this doc shows that libp2p
*identity* is what BIP39 backs up.

§The-identity-flows-through-the-stack: mnemonic →
PBKDF2-HMAC-SHA512 → 32-byte seed → Ed25519 key pair →
peer-id (multihash of public key) → discovery / dialing /
ACL. §Identity-is-a-derivation-chain-not-a-stored-blob.

§Cycle-141-and-cycle-119-need-this-named: Endo's daemon
currently has §identity-as-stored-blob (locator file); a
shift toward §identity-as-derivation-chain would enable
portability without changing what the daemon does
internally.

## §Provenance-discipline of the doc itself

§Six-section-structure: Overview / BIP39 Mnemonic Phrases /
API Reference / Usage Scenarios / Important Considerations
/ Error Handling. §Reference-style-with-runnable-examples.

§Every-API-method-has-a-code-example. §Each-scenario-is-
end-to-end-runnable (not just signatures). §Errors-are-
shown-as-exact-strings.

§Security-Note-callouts (two of them) draw the eye to the
non-skippable warnings. §Visual-discipline-for-security-
content.

§Comparison-with-Endo-docs: Endo's design docs (cycles
117-119) are more design-prose than reference; ocap-
kernel's identity-backup-recovery.md is more reference-
with-examples. §Two-doc-genres-serve-different-audiences;
§ocap-kernel-targets-implementers; §Endo-targets-design-
discussion. §Synthesis-target: §reference-with-runnable-
examples is a useful complement to design-prose for
end-user-facing capabilities.

## §Reference-not-substrate stance (continued)

§Vocabulary-borrowing-without-code-borrowing applies:
adopting the §identity-from-seed and §verify-before-recovery
patterns doesn't require importing BIP39 code. Endo could
choose its own derivation (Ed25519 from non-BIP39 sources,
or hash-based identifiers, etc.) and still adopt the
*structural* patterns.

§Citation-when-borrowing: a future Endo design adopting
§verify-before-recovery should cite this doc and §scenario-4.
