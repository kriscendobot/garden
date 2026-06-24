# scholar-ingest-cask-2 — done (gardener 52, endolinbot, 2026-06-24)

Continued the `kriskowal/cask` library ingest (cycle 3). All four target docs shared the
file-specific commit `cdb975d8…` and were absent from the library, so all four were fresh
ingests (no idempotency skips). Pushed to `journal2` as commit `4e2fb6f9` (38 files,
+1280 lines).

## Sources ingested (4 docs → 18 sections)
- `doc/design/package-taxonomy.md` → 5 (package-categories, hashtree-vs-arraytree,
  naming-conventions, design-patterns, future-structures).
- `doc/design/net-crypto.md` → 6 (overview-and-identity, authorization-member-table,
  noise-ik-handshake, transport-keys-and-forward-secrecy, encrypted-packet-and-replay,
  primitives-threat-model-and-lifecycle). **The authoritative casknet crypto doc.**
- `doc/design/net-session-init-design.md` → 5 (command-vocabulary-and-detection,
  session-state-and-envelope, inner-command-wire-formats, security-considerations current;
  psk-handshake-packet-formats **superseded**).
- `doc/design/net-design.md` → 2 (backpressure-and-traffic-class-wake,
  lost-notification-coordination).

## Noise IK ↔ PSK reconciliation (the job's key deliverable) — RESOLVED
`net-crypto.md` is the current design (Noise IK, x25519 ephemeral DH, forward secrecy,
ed25519 identity, member-table auth) and explicitly names the PSK + BLAKE2b-128 form "the
previous PSK-based design." So:
- Rewrote the `noise-ik-session-establishment` concept (abstract now Noise-IK-current;
  six new sections added; aliases expanded; the deferred Common-confusions block replaced
  with a dated "Resolved" note).
- `cask--net-session-init-design--psk-handshake-packet-formats` → `status: superseded`
  (`superseded_by` net-crypto noise-ik); the net-crypto handshake section carries the
  reciprocal `supersedes`.
- Refined the prior cycle's `cask--architecture--layers-0-1` `notes:` to flag its PSK
  handshake as the previous design and point at the reconciliation.

## Concepts
Re-audited `noise-ik-session-establishment`. Added `casknet-wire-protocol`,
`member-table-authorization`, `cask-block-backbones`. Extended `codel-send-buffer-shedding`
(net-design enqueue-side sections + drainNotify/backpressure aliases), `cask-reducer-pattern`
and `parallel-arrays-columnar` (package-taxonomy rows).

## Indexes
`sources/README.md` (+4), `concepts/README.md` (+3 new, noise-ik row reworded),
`keywords.md` (+~48 lines, deduped 2 lines that collided with prior cycle), topics
networking (+13), data-structures (+5), capability-security (+1), repository-governance
(+1). `sections/README.md` is a generated mega-listing that does not index the cask corpus
(prior cask cycles skipped it likewise) — left untouched.

## Follow-on
Posted `scholar-ingest-cask-3` naming the remainder: the GC family
(gc-and-retention / gc-concurrent-design / store-gc-design), dbstore-design, the protocol
family (protocol / protocol2 / protocol2-arch / cryptography), trace2 (likely supersedes
the cask--trace sketch), the cell/entry family (cell-capabilities 35 KB, cells,
cells-and-entries, caskroot-design, ocaps), the data-structure design family (array /
sorted-array / allocator / bigint / blob / dir / dir-v2 / root / nursery / verbs /
membertable / membership-next-steps / cluster-provisioning / dir-benchmark),
status / CONTRIBUTING / style, and the comment-fragment clusters in cask.go,
blob/chunker.go, sendbuffer/buffer.go, net/.

## Process note
The shared journal worktree races on `keywords.md`/README appends; worked in an isolated
`git worktree add --detach origin/journal2` and union-resolved the keywords conflict
(append-only, order-free). A `git commit --amend` segfaulted once mid-resolve but left an
only-dangling object; the push landed cleanly (verified files + superseded flag on origin,
keywords marker-free, "Noise IK" entry deduped to 1).

Self-improvement: nothing this time. The cross-source supersession discipline
(section-level superseded/supersedes + a concept-level "Resolved" confusions note) is
exactly what conventions.md prescribes and handled the same-commit two-doc contradiction
without new machinery.
