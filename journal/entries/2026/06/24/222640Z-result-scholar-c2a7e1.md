---
ts: 2026-06-24T22:26:40Z
kind: result
role: scholar
project: cask
repo: kriskowal/cask
refs:
  - jobs/doin/scholar-ingest-cask-2.md
---

# Scholar cask ingest cycle 3 (job scholar-ingest-cask-2)

Continued the `kriskowal/cask` design-doc ingest. All four target docs shared the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); none were already present in the library, so all four were fresh ingests (no idempotency skips).

## Sources ingested (4 docs, 18 sections)

- **doc/design/package-taxonomy.md** → 5 sections (`package-categories`, `hashtree-vs-arraytree`, `naming-conventions`, `design-patterns`, `future-structures`). Filed under data-structures / content-addressed-storage / repository-governance. Pairs with the README's `cask--readme--package-taxonomy` (soft-flag overlap).
- **doc/design/net-crypto.md** → 6 sections (`overview-and-identity`, `authorization-member-table`, `noise-ik-handshake`, `transport-keys-and-forward-secrecy`, `encrypted-packet-and-replay`, `primitives-threat-model-and-lifecycle`). The **authoritative** casknet crypto doc.
- **doc/design/net-session-init-design.md** → 5 sections (`command-vocabulary-and-detection`, `session-state-and-envelope`, `inner-command-wire-formats`, `security-considerations` all current; `psk-handshake-packet-formats` **superseded**).
- **doc/design/net-design.md** → 2 sections (`backpressure-and-traffic-class-wake`, `lost-notification-coordination`). Enqueue-side send-buffer backpressure.

## noise-ik-session-establishment re-audit (the job's key deliverable)

The PSK-vs-Noise-IK open question is **resolved**. `net-crypto.md` is the current design (Noise IK handshake, x25519 ephemeral Diffie-Hellman, forward secrecy, ed25519 identity, member-table authorization) and explicitly calls the PSK + BLAKE2b-128 form "the previous PSK-based design." Actions taken:

- Rewrote the `noise-ik-session-establishment` concept abstract to present Noise IK as the current implemented form, added the six net-crypto/net-session-init sections to its table, expanded aliases (forward secrecy, x25519, ed25519, directional keys, WireGuard-style, ensureSession, Split), and replaced the deferred Common-confusions block with a "Resolved (2026-06-24)" note.
- Marked `cask--net-session-init-design--psk-handshake-packet-formats` `status: superseded` (`superseded_by: cask--net-crypto--noise-ik-handshake`); `cask--net-crypto--noise-ik-handshake` carries the reciprocal `supersedes:`.
- Refined the `notes:` on the prior cycle's `cask--architecture--layers-0-1-block-transfer-and-session` to flag its PSK handshake as the previous design and point at the reconciliation (kept `status: current` as a layered overview).

## Concepts

- Re-audited: `noise-ik-session-establishment` (above).
- Added: `casknet-wire-protocol` (reversed-response command set + AEAD envelope + inner-command formats), `member-table-authorization` (ed25519 identity + accepted-peer table), `cask-block-backbones` (hashtree vs arraytree + adaptive index width).
- Extended: `codel-send-buffer-shedding` (added the two net-design enqueue-side sections + drainNotify/backpressure/PopPriority aliases); `cask-reducer-pattern` and `parallel-arrays-columnar` (added the package-taxonomy section rows).

## Indexes updated

`sources/README.md` (+4 rows), `concepts/README.md` (+3 new rows, noise-ik row reworded), `keywords.md` (+~50 lines), `topics/networking.md` (+13 rows), `topics/data-structures.md` (+5 rows), `topics/capability-security.md` (+1), `topics/repository-governance.md` (+1). `sections/README.md` is a generated mega-listing that does not index the cask corpus (prior cask cycles skipped it likewise), so it was left untouched.

## Deferred remainder (follow-on posted)

Posted `scholar-ingest-cask-3` naming what remains: the GC family (`gc-and-retention.md`, `gc-concurrent-design.md`, `store-gc-design.md`), `dbstore-design.md`, `protocol.md`/`protocol2.md`/`protocol2-arch.md`, `trace2.md` (likely supersedes the `cask--trace` interface sketch), the cell/entry family (`cell-capabilities.md` 35 KB, `cells.md`, `cells-and-entries.md`, `caskroot-design.md`, `ocaps.md`), the data-structure design family (`array-design.md`, `sorted-array-design.md`, `allocator-design.md`, `bigint-design.md`, `blob-design.md`, `dir-design.md`, `dir-design-v2.md`, `root-design.md`, `nursery.md`, `verbs.md`, `membertable-design.md`, `membership-next-steps.md`, `cluster-provisioning.md`, `dir-benchmark.md`), `cryptography.md` (the "Option A/B" doc net-crypto realizes), `status.md`, `CONTRIBUTING.md`, `style.md`, and the comment-fragment clusters in `cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, and `net/`.

Self-improvement: nothing this time. The cross-source supersession discipline (section-level `superseded`/`supersedes` plus a concept-level "Resolved" Common-confusions note) was exactly what `conventions.md` § Staleness/supersession prescribes, and it handled the same-commit two-doc contradiction cleanly without new machinery.
