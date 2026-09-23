---
title: "Incarnation identity and peer-restart detection (why a state reset preserves network identity but regenerates the incarnationId)"
source: packages/ocap-kernel/src/Kernel.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/Kernel.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/Kernel.ts
source_line_range: "704-734"
source_branch: main
source_commit: 052f4d4865b39df29f8f67fdffa3c52ef17b4282
source_date: 2026-05-12
comment_subject: A kernel-state reset preserves the identity keys (keySeed, peerId, ocapURLKey) so the kernel keeps its network identity across the wipe, but deliberately does NOT preserve the incarnationId, whose purpose is to signal to remote peers that local state was wiped so they clear seq-dedup and c-list bookkeeping for this peer; preserving it would defeat the peer-restart detection.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-28
ingested_by: scholar
topics: [persistence, daemon]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the #resetKernelState incarnation-identity comment in Kernel.ts. See [[ocap-kernel]].
---

## Abstract

`#resetKernelState` carries the single richest design comment in `Kernel.ts`, and it draws a careful line between two kinds of identity. On a state reset that is *not* an identity recovery, the kernel preserves its **identity keys** (`keySeed`, `peerId`, `ocapURLKey`) so it keeps the **same network identity** across the wipe, but it deliberately does **not** preserve the **`incarnationId`**. The incarnationId's whole purpose is to **signal to remote peers that local state has been wiped**, so those peers clear any **sequence-deduplication** and **c-list** (capability-list) bookkeeping they hold for this peer. Preserving the incarnationId across a state wipe would defeat the **peer-restart detection** introduced in #948. The only time identity keys are also cleared is `resetIdentity: true`, used when recovering from a BIP39 mnemonic — that is regenerating identity from scratch, so the network identity is *meant* to change.

## Body

### Two reset modes, one careful distinction

```ts
#resetKernelState({
  resetIdentity = false,
}: { resetIdentity?: boolean } = {}): void {
  if (resetIdentity) {
    // Full reset including identity - used when recovering from mnemonic
    this.#kernelStore.reset();
  } else {
    // Preserve identity keys so network address survives restart.
    // `incarnationId` is deliberately omitted: it must be regenerated
    // so remote peers can detect the state loss via the handshake.
    this.#kernelStore.reset({
      except: ['keySeed', 'peerId', 'ocapURLKey'],
    });
  }
}
```

The default branch keeps three keys (`keySeed`, `peerId`, `ocapURLKey`) so the kernel reappears on the network as the *same* peer after a state wipe. The `incarnationId` is conspicuously **absent** from the `except` list: it must be regenerated.

### Why the incarnationId must change — peer-restart detection

The method-level JSDoc spells out the protocol reasoning:

> Identity keys (`keySeed`, `peerId`, `ocapURLKey`) are preserved so the kernel keeps the same network identity across the reset. The `incarnationId` is deliberately *not* preserved: its whole purpose is to signal to remote peers that local state has been wiped so they clear any seq-dedup / c-list bookkeeping for this peer. Preserving it across a state wipe defeats the peer-restart detection introduced in #948.

This is the crux. A peer that talks to this kernel maintains per-peer state: a sequence-number window for deduplicating retransmitted messages, and a c-list mapping the remote references it has exchanged. If this kernel wipes its local state but reappears with the *same* `peerId` and the *same* `incarnationId`, its peers cannot tell that anything happened — they keep deduplicating against a sequence window this kernel no longer honors, and they keep c-list entries this kernel no longer recognizes. By **regenerating** the incarnationId while **keeping** the peerId, the kernel presents the same network address but a fresh incarnation marker; the peers detect the new incarnation during the handshake and reset their per-peer bookkeeping. The peerId answers "who"; the incarnationId answers "which lifetime."

### The mnemonic-recovery exception

`resetIdentity: true` calls the unfiltered `kernelStore.reset()`, clearing identity keys as well. The constructor reaches this path when `resetStorage` is set together with a `mnemonic` (`this.#resetKernelState({ resetIdentity: Boolean(options.mnemonic) })`): recovering from a mnemonic *is* regenerating the identity from a known seed, so changing the network identity is the intent, not a hazard.

### Why this matters to the garden

This is a clean worked example of separating **durable network identity** from a **restart-generation marker**, with explicit protocol-level reasoning for why the two must not be conflated. The garden's daemon-persistence and identity work (the cycle-119 `dp` design, and ocap-kernel's own `docs/identity-backup-recovery.md` ingest, which treats identity as a *derivation chain* rather than a stored blob) face the adjacent question of how a restarted node re-establishes itself to its peers without losing or silently corrupting their view of it. The incarnationId is ocap-kernel's answer to the "I restarted; forget what you knew about my message sequence and my exported references" signal — a primitive Endo's remote layer would need an analog of for the same correctness property.

## Lineage note

Sequence-deduplication and c-list bookkeeping are SwingSet/CapTP-lineage remote-comms concepts; the incarnationId-as-restart-signal is ocap-kernel's specific mechanism (introduced in #948, with the regenerate-on-reset behavior fixed in #950, the commit that last touched this file). The Ken-protocol self-assessment ingest (`docs/ken-protocol-assessment.md`) covers the related exactly-once / retransmit machinery this detection guards. See [[ocap-kernel]] for the lineage flag.

Source: [packages/ocap-kernel/src/Kernel.ts](https://github.com/MetaMask/ocap-kernel/blob/052f4d4865b39df29f8f67fdffa3c52ef17b4282/packages/ocap-kernel/src/Kernel.ts) (lines 704-734) at commit `052f4d4`.
