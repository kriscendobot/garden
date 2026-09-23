---
title: Command constants, the reversed-response mirror convention, and fixed handshake packet sizes
source: net/crypto.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/crypto.go
source_line_range: "19-66"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The casknet command vocabulary, the response-is-request-reversed naming convention, status codes, and the two fixed Noise-IK handshake packet sizes (176 / 121 bytes)
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
notes: |
  Implementation-side confirmation of the design-doc concept
  casknet-wire-protocol. The code's Noise-IK packet sizes
  (initPacketSize 176, tiniPacketSize 121) refine the design's
  approximate ~144 / ~89 numbers and supersede the PSK-era 82 / 65
  detection minimums. See `## Comment-vs-code note`.
---

> Abstract: `net/crypto.go` opens with the constant blocks that are the implementation-side source-of-truth for casknet's command vocabulary. Eleven 4-byte command codes are defined, and the load-bearing naming convention is stated in two comment lines: **every response or acknowledgement command is the request command spelled backwards** (`init`/`tini`, `stor`/`rots`, `casc`/`csac`, `gcgc`/`cgcg`, `mass`/`ssam`; `load` is answered by a `stor` carrying the block back). Alongside are the fixed packet-size budgets for the two Noise-IK handshake messages (`initPacketSize` = 176 bytes, `tiniPacketSize` = 121 bytes), the envelope field sizes (`sessionIDSize` 32, `nonceSize` 12, `authTagSize` 16, `minEncryptedPacketSize` 64), and the three handshake status codes (success / auth-failed / not-authorized).

This section carries the constant-block comments that define casknet's protocol vocabulary. It is the in-code realization of the design-doc concept [[casknet-wire-protocol]]; that concept's abstract is the prose summary, this file is the authoritative implementation surface.

## Command vocabulary and the mirror convention

```go
// Command constants.
// Response/ack commands are the request command reversed.
const (
	commandINIT = "init" // session init request
	commandTINI = "tini" // session init response (mirror)
	commandSTOR = "stor" // store block
	commandLOAD = "load" // load block
	commandROTS = "rots" // store acknowledgement (mirror of stor)
	commandCASC = "casc" // compare-and-swap cell
	commandCSAC = "csac" // CAS response (mirror of casc)
	commandGCGC = "gcgc" // garbage collection request
	commandCGCG = "cgcg" // garbage collection response (mirror of gcgc)
	commandMASS = "mass" // weigh request
	commandSSAM = "ssam" // weigh response (mirror of mass)
)
```

The convention "response/ack commands are the request command reversed" is the whole naming rule. `stor` reversed is `rots` (the store acknowledgement); `casc` reversed is `csac`; `gcgc` reversed is `cgcg`; `mass` reversed is `ssam`; `init` reversed is `tini`. The one asymmetry: a `load` request is answered by a `stor` (the block is shipped back under the store command), so `load` has no reversed-name mirror of its own. The `mass`/`ssam` weigh pair is implemented in `crypto.go` (the build/parse plaintext helpers exist) but is not enumerated in the design-doc concept's command table, which predates it; the code is the more complete inventory.

## Fixed handshake packet sizes and envelope field widths

```go
// Noise IK message 1: "init" + session_id + ttl + ephemeral_pub
//   + encrypted(static_pub, 48B) + encrypted(ed25519_pub + timestamp, 40B + 16B tag)
initPacketSize = 4 + 32 + 4 + 32 + 48 + 56 // 176 bytes
// Noise IK message 2: "tini" + session_id + ttl + ephemeral_pub
//   + encrypted(status + ed25519_pub, 33B + 16B tag)
tiniPacketSize = 4 + 32 + 4 + 32 + 49 // 121 bytes

sessionIDSize = 32
nonceSize     = 12
authTagSize   = 16

// Minimum encrypted packet: session_id + nonce + 4-byte command + tag
minEncryptedPacketSize = sessionIDSize + nonceSize + 4 + authTagSize // 64
```

The init packet carries, after the 4-byte command + 32-byte session_id + 4-byte TTL + 32-byte ephemeral x25519 public key, two Noise-encrypted blobs: the 48-byte encrypted static x25519 key (32-byte key + 16-byte tag) and a 56-byte blob encrypting the node's **ed25519 identity public key plus a timestamp** (40 bytes of plaintext + 16-byte tag). That ed25519 key in the payload is what the membership check authorizes (see [[member-table-authorization]] and the membership section of this source). The tini response echoes session_id and granted TTL, supplies the responder's ephemeral key, and encrypts a 33-byte status + ed25519-key blob (49 bytes with tag).

## Handshake status codes

```go
const (
	statusSuccess       = 0
	statusAuthFailed    = 1
	statusNotAuthorized = 2
)
```

`statusNotAuthorized` (2) is the rejection a responder returns when the initiator's decrypted ed25519 key is absent from the member table; `statusAuthFailed` (1) covers cryptographic failure. These are the codes carried in the tini response (or in the plaintext-rejection tini built by `buildInitResponseReject` when no identity is configured).

## Comment-vs-code note

The packet-size numbers differ across the three places casknet is documented, and the code is authoritative for what is actually transmitted:

- `initPacketSize` = **176**, `tiniPacketSize` = **121** (this file, the running implementation).
- The [[noise-ik-session-establishment]] concept abstract gives approximate **~144 / ~89** byte figures drawn from `doc/design/net-crypto.md`. The 176 / 121 constants are the exact realization (the ~144 init figure omits the encrypted ed25519-key blob that the const and the line-37/38 comment include).
- The [[casknet-wire-protocol]] concept abstract gives **82 / 65** byte detection minimums; those are the **superseded PSK-era** handshake sizes, not the Noise-IK sizes.

Use 176 / 121 as casknet's current Noise-IK handshake packet sizes.

Source: [net/crypto.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/crypto.go) at commit `cdb975d8` (lines 19-66).
