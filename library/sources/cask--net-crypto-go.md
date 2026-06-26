---
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/crypto.go
source_line_range: "1-908"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The casknet SessionManager — command vocabulary, the byte-exact wire layouts of every command, counter-nonce replay protection, and three implementation-only design notes (mutual membership, traffic-class clamping, send-only key persistence)
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
section_count: 4
status: current
notes: |
  Second comment-fragment source of the cask `net/` package (cycle 16),
  following the root `cask.go` (cycle 15). `net/crypto.go` is the
  implementation-side source-of-truth for the casknet protocol the
  `doc/design/net-*.md` docs describe in prose: the command constants and the
  reversed-response convention realize the casknet-wire-protocol concept; the
  build/parse byte-layout comments realize the inner-command-wire-formats
  section; the counter-nonce + monotonic-recv-counter code realizes the
  encrypted-packet-and-replay section. Three design notes are documented only
  in this file's comments (not the design docs): mutual membership via
  MemberAdd, the bestTrafficClass clamp, and the recvKey-not-persisted disk
  asymmetry. One comment-vs-code drift noticed and flagged: buildInitPacket's
  layout comment (144 bytes, omits the ed25519-key blob) lags the
  initPacketSize const (176 bytes); candidate upstream comment-fix missive.
---

> Abstract: `net/crypto.go` is the `SessionManager` of the `casknet` package — the implementation-side source-of-truth for CASK's encrypted-UDP inter-node protocol. Its four longform comment clusters carry: (1) the **command vocabulary** — eleven 4-byte command codes and the load-bearing "response is the request command spelled backwards" convention, plus the fixed Noise-IK handshake packet sizes (176 / 121 bytes) and status codes; (2) the **byte-exact wire layouts** of every command plaintext, packed by the `build*Plaintext` / `parse*Plaintext` helpers (init/tini, load/store/store-ack, CAS/CAS-response, collect/collect-response, weigh/weigh-response); (3) the **counter-nonce replay protection** — the 12-byte AEAD nonce is the 8-byte big-endian send counter, and a strictly-increasing receive counter rejects replays; and (4) three **implementation-only design notes** — `MemberAdd` makes membership mutual after a handshake, `bestTrafficClass` clamps a session's claimable priority, and only the send key is persisted so disk-loaded sessions cannot decrypt.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [command-constants-and-mirror-convention](../sections/cask--net-crypto-go--command-constants-and-mirror-convention.md) | networking, content-addressed-storage | current |
| [command-plaintext-wire-layouts](../sections/cask--net-crypto-go--command-plaintext-wire-layouts.md) | networking | current |
| [counter-nonce-and-replay-protection](../sections/cask--net-crypto-go--counter-nonce-and-replay-protection.md) | networking, capability-security | current |
| [membership-mutuality-traffic-class-and-key-asymmetry](../sections/cask--net-crypto-go--membership-mutuality-traffic-class-and-key-asymmetry.md) | capability-security, networking | current |

## Provenance

- Fetched 2026-06-26 from `kriskowal/cask@main` (file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`, 2026-02-14, Kris Kowal) via a sparse scratch clone under the bot home.
- Second comment-fragment ingest of the cask corpus and the first of the `net/` package; follows the root `cask.go` (cycle 15).
- The `crypto.go` comments are the implementation-side counterpart to the `cask--net-crypto`, `cask--net-session-init-design`, and `cask--net-design` design-doc sources; the sections cross-reference those rather than restating them.
- Comment-vs-code drift noticed: `buildInitPacket`'s layout comment (144 bytes, omits the encrypted ed25519-key blob) lags the `initPacketSize` const (176 bytes); corroborated by `net/noise.go` and `MemberLookupFunc`. Flagged for a possible upstream comment-fix missive (the scholar does not push upstream).
