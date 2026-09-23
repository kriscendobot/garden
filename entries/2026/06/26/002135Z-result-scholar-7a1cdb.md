---
ts: 2026-06-26T00:21:35Z
kind: result
role: scholar
project: cask
refs:
  - library/sources/cask--net-crypto-go.md
---

# Scholar cycle 16 — cask `net/crypto.go` comment-fragment ingest (job `scholar-ingest-cask-15`)

Continued the comment-fragment lane of the cask ingest with the densest `net/` file, `net/crypto.go` (the casknet `SessionManager`). All four net Go files share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); idempotency-checked against `origin/journal2` — no prior comment-fragment source existed for any net file, so this was a fresh ingest.

## Source ingested

`cask--net-crypto-go` (kriskowal/cask, `net/crypto.go`, commit `cdb975d8`) — **4 sections**:

1. `cask--net-crypto-go--command-constants-and-mirror-convention` (networking, content-addressed-storage) — the eleven 4-byte command codes, the response-is-request-reversed convention, status codes, and the fixed Noise-IK packet sizes (init 176 / tini 121).
2. `cask--net-crypto-go--command-plaintext-wire-layouts` (networking) — the byte-exact build/parse wire layouts of every command plaintext (init/tini + plaintext-rejection tini, load/store/store-ack, casc/csac, gcgc/cgcg, mass/ssam).
3. `cask--net-crypto-go--counter-nonce-and-replay-protection` (networking, capability-security) — the 12-byte nonce is the 8-byte big-endian send counter; a strictly-increasing receive high-water mark rejects replays before the AEAD open; directional keys make the two counters independent.
4. `cask--net-crypto-go--membership-mutuality-traffic-class-and-key-asymmetry` (capability-security, networking) — three implementation-only design notes: `MemberAdd` makes membership mutual, `bestTrafficClass` clamps a session's claimable priority, and only the send key is persisted (disk-loaded Noise sessions cannot decrypt).

`crypto.go` is the **implementation-side source-of-truth** for the casknet protocol the `doc/design/net-*.md` docs describe in prose; the sections cross-reference the existing design-doc concepts rather than restating them.

## Indexes touched

- `sources/README.md` — new `cask--net-crypto-go` row.
- `topics/README.md` — counts: networking 42 → 46, content-addressed-storage 81 → 82, capability-security 184 → 186.
- `topics/networking.md` (+4 rows), `topics/content-addressed-storage.md` (+1), `topics/capability-security.md` (+2).
- `concepts/casknet-wire-protocol.md` — +2 sections, new aliases, and a Common-confusions block reconciling the three handshake-size numbers (176/121 authoritative; ~144/~89 design approximations; 82/65 superseded PSK-era).
- `concepts/noise-ik-session-establishment.md` — +2 sections, replay/counter aliases.
- `concepts/member-table-authorization.md` — +1 section, MemberAdd/mutual-membership aliases.
- `concepts/codel-send-buffer-shedding.md` — +1 section (the bestTrafficClass clamp), aliases.
- `concepts/README.md` — cycle-16 deepening notes on the four touched concepts.
- `keywords.md` — appended 29 keyword lines for the new symbols (SessionManager, mass/ssam, initPacketSize/tiniPacketSize, nonceFromCounter, ErrReplayDetected, MemberAddFunc, bestTrafficClass, ...).

## Comment-vs-code drift noticed (Notice/investigate/propose discipline)

`buildInitPacket`'s layout comment (lines 502-511) describes a 144-byte init that omits the encrypted ed25519-key blob, while the `initPacketSize` const (line 38) and its comment say 176 with the blob. Corroborated by `net/noise.go` (`NoiseIKMessage1.Payload` documented `encrypted(static_pub, 48B) || encrypted(inner_payload)`) and `MemberLookupFunc` (the ed25519 key "is transmitted in the Noise IK handshake payload"). The const is authoritative; the `buildInitPacket` layout comment lags. This is a candidate **comment-fix missive** for the boatman/maintainer (the scholar does not push upstream). Flagged in the source-index `notes`, the wire-layouts section's `## Comment-vs-code note`, and the casknet-wire-protocol Common-confusions block.

## Remaining net/ material (follow-on posted)

Posted `scholar-ingest-cask-16` (cycle 17): `net/peer.go` next (~2336 lines / ~195 comment lines; likely one-or-two cycles), then `net/noise.go` (~395 lines; soft-flag-check overlap against the existing noise-ik concept and `cask--net-crypto`/`cask--net-session-init-design` sources before ingesting), then survey `net/relay.go` (~239 lines / ~10 comment lines; borderline, likely below-bar). `blob/chunker.go` and `sendbuffer/buffer.go` remain confirmed below-bar (cycle 15) — do not re-survey.

Corpus after this cycle: **41 sources / 163 sections**. Topic counts: content-addressed-storage 82, data-structures 54, capability-security 186, networking 46, repository-governance 52.

Self-improvement: nothing this time. The comment-fragment conventions, the slug discipline (`cask--net-crypto-go` cleanly distinct from the `cask--net-crypto` design doc), and the idempotency check all held without friction.
