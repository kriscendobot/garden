---
title: The byte-exact wire layouts of every casknet command plaintext
source: net/crypto.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/crypto.go
source_line_range: "502-908"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The per-command byte-layout block comments on the build/parse helpers — the implementation-side wire-format spec for init/tini, load/store/store-ack, CAS/CAS-response, collect/collect-response, and weigh/weigh-response
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking]
status: current
notes: |
  Implementation-side realization of the design-doc section
  cask--net-session-init-design--inner-command-wire-formats. The build*/parse*
  layout comments are the authoritative byte offsets. Records a comment-vs-code
  drift on buildInitPacket (layout comment says 144 / omits the ed25519-key
  blob; initPacketSize const says 176) flagged for a possible upstream missive.
---

> Abstract: The back half of `net/crypto.go` is a family of `build*Plaintext` / `parse*Plaintext` helpers, each carrying a block comment that lays out its packet byte-by-byte. Taken together these comments are the **implementation-side source-of-truth for the entire casknet wire format**: the two handshake packets (`init`, `tini`, plus the short plaintext-rejection tini), and the steady-state encrypted-payload commands `load` (44 B), `stor` (variable; 4+8+32 + 12-byte metadata footer + block), `rots` store-ack (count + holdback + hashes), `casc` compare-and-swap (141 B), `csac` CAS response (45 B), `gcgc` collect (12 B), `cgcg` collect response (variable; stats + error string), `mass` weigh (44 B), and `ssam` weigh response (variable; weight + error string). Every steady-state command begins with the 4-byte command code and (except store-ack) an 8-byte big-endian `span_id` correlation ID; multi-byte integers are big-endian throughout.

This section carries the byte-layout comments verbatim. It is the in-code counterpart to the design-doc section [cask--net-session-init-design--inner-command-wire-formats](cask--net-session-init-design--inner-command-wire-formats.md); read that for the prose framing and this for the offsets the implementation actually packs. Concept: [[casknet-wire-protocol]].

## Handshake packets (init / tini)

```text
init (Noise IK message 1):
	0-4:    "init"
	4-36:   session_id (32B)
	36-40:  ttl_seconds (4B)
	40-72:  ephemeral_pub (32B)
	72+:    noise_payload (encrypted static key 48B || encrypted ed25519_pub+timestamp)

tini (Noise IK message 2):
	0-4:   "tini"
	4-36:  session_id (32B)
	36-40: ttl_seconds (4B)
	40-72: ephemeral_pub (32B)
	72+:   noise_payload (encrypted status)
```

`buildInitResponseReject` builds a short **plaintext** tini (4+32+4+1 = 41 bytes) carrying only a status byte at offset 40, used when the Noise handshake cannot proceed (no local identity). `parseInitResponsePacket` distinguishes the two: a packet shorter than `4+32+4+32+1` is a plaintext rejection (read status at offset 40); otherwise it is a full Noise tini.

## Steady-state command plaintexts

The inner plaintext (what rides inside the AEAD envelope) for each command:

```text
load  (44 B):   "load" | spanID(8) | hash(32)
stor  (var):    "stor" | spanID(8) | hash(32) | metadata(cask.MetadataSize=12) | block(0..1024)
rots  (var):    "rots" | count(1) | holdbackNs(8) | hash[count](32 each)
casc  (141 B):  "casc" | spanID(8) | trafficClass(1) | nonce(32) | address(32) | old(32) | new(32)
csac  (45 B):   "csac" | spanID(8) | success(1) | currentHash(32)
gcgc  (12 B):   "gcgc" | spanID(8)
cgcg  (var):    "cgcg" | spanID(8) | blocksRetained(8) | blocksCollected(8) | status(1) | errLen(4) | errMsg
mass  (44 B):   "mass" | spanID(8) | hash(32)
ssam  (var):    "ssam" | spanID(8) | weight(8) | status(1) | errLen(4) | errMsg
```

Notes the comments make load-bearing:

- The `stor` metadata field is **always exactly `cask.MetadataSize` (12) bytes** (the block metadata footer: height / numLinks / dataLen / reserved); `buildStorePlaintext` and `parseStorePlaintext` both pin it. The block payload that follows is 0 to 1024 bytes.
- `casc` carries a 1-byte **trafficClass** between the span ID and the 32-byte capability nonce. This is the priority figure consumed by the CoDel scheduler (see [[codel-send-buffer-shedding]]); it is the only steady-state command that carries a traffic class inline, because cell compare-and-swap is the latency-sensitive control operation.
- `rots` (store-ack) is the one steady-state command that does **not** carry a span ID: it carries a 1-byte hash `count`, an 8-byte `holdbackNs` (a retention holdback duration), then `count` 32-byte hashes.
- The two error-bearing responses (`cgcg`, `ssam`) end with a 4-byte big-endian error-message length followed by the variable-length UTF-8 error string; a zero length and `status` byte 0 mean success.

## Comment-vs-code note (flagged for upstream)

The `initPacketSize` constant (line 38) and its line-37 comment say the init payload encrypts the static key (48 B) **and** the ed25519 public key + timestamp (56 B), totalling **176 bytes**. The `buildInitPacket` doc comment (lines 502-511) describes the payload as encrypted static key 48 B + encrypted timestamp 24 B, totalling **144 bytes**, and omits the ed25519-key blob. `net/noise.go` corroborates the const: `NoiseIKMessage1.Payload` is documented `encrypted(static_pub, 48B) || encrypted(inner_payload)`, and `MemberLookupFunc` (line 68-70) states the ed25519 key "is transmitted in the Noise IK handshake payload." The `buildInitPacket` layout comment is the lagging one (it predates adding the ed25519 key to the inner payload). This is a candidate comment-fix missive: bring the `buildInitPacket` layout comment up to 176 bytes with the ed25519-key blob shown.

Source: [net/crypto.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/crypto.go) at commit `cdb975d8` (lines 502-908).
