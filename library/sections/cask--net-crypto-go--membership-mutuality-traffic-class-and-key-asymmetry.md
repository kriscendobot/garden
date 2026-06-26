---
title: Mutual membership, traffic-class clamping, and the send-only session-key persistence asymmetry
source: net/crypto.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/crypto.go
source_line_range: "68-352"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: Three implementation-only design notes — MemberAdd makes membership mutual after a handshake, bestTrafficClass clamps an incoming session's claimable priority, and only the send key is persisted so disk-loaded sessions cannot decrypt
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [capability-security, networking]
status: current
notes: |
  Three design notes that live only in the crypto.go comments, not in the
  design docs: mutual membership via MemberAdd, the bestTrafficClass clamp,
  and the recvKey-not-persisted session-cache-vs-disk asymmetry.
---

> Abstract: Three design decisions are documented only in `net/crypto.go`'s comments, not in the `doc/design/` prose. (1) **Membership is made mutual by the handshake**: `MemberAddFunc` is called after a successful Noise IK handshake so that **both** initiator and responder add each other's ed25519 key to their local member tables (and must be idempotent). (2) **A session's claimable priority is clamped**: each session carries a `bestTrafficClass` (the lowest, best class it may claim); incoming datagrams asserting a lower/higher-priority class are clamped to this value, and unknown sessions default to class 128 (the worst). (3) **Only the send key is persisted**: a session's state on disk stores `sendKey` as its single `SessionKey`; `recvKey` is not in the schema, so a session reloaded from disk cannot decrypt incoming traffic — accepted because sessions are short-lived and the in-memory cache is the primary path.

This section gathers the implementation-only design notes that the design-doc concepts do not cover. Related concepts: [[member-table-authorization]] (the table these notes gate on), [[codel-send-buffer-shedding]] (the traffic-class scheduler the clamp feeds), [[noise-ik-session-establishment]] (the handshake that produces the two keys).

## Membership is mutual (MemberLookup checks, MemberAdd completes)

```go
// MemberLookupFunc checks whether an ed25519 public key is authorized.
// The key is transmitted in the Noise IK handshake payload.
type MemberLookupFunc func(ctx context.Context, pubKey ed25519.PublicKey) (bool, error)

// MemberAddFunc adds an ed25519 public key to the local membership table.
// Called after a successful Noise IK handshake to ensure mutual membership:
// both the initiator and responder add each other's key.
// Implementations should be idempotent (no error if already a member).
type MemberAddFunc func(ctx context.Context, pubKey ed25519.PublicKey) error
```

`MemberLookup` is the authorization gate the responder applies to the initiator's decrypted ed25519 key (an unknown key yields a `statusNotAuthorized` rejection). `MemberAdd` is the symmetric completion: a successful handshake is treated as a mutual admission, so each side records the other. The idempotency requirement matters because a peer that is already a member must not error on re-admission across repeated handshakes. This is an implementation-side refinement of [[member-table-authorization]]: the design doc describes the server checking the initiator; the code additionally makes both sides remember each other.

## Traffic-class clamping (a session cannot escalate its own priority)

```go
// CreateSession ...
// bestTrafficClass is the lowest traffic class this session may claim;
// incoming datagrams with a lower (higher-priority) class are clamped to this value.

// BestTrafficClass returns the best (lowest) traffic class for a session.
// Incoming datagrams claiming a lower class should be clamped to this value.
func (sm *SessionManager) BestTrafficClass(sessionID cask.Hash) uint8 {
	...
	return 128 // worst possible class for unknown sessions
}
```

Each session is provisioned with a `bestTrafficClass` ceiling (lower number = higher priority, per the cask trace model). A datagram on that session that claims a better (lower) class than the session is entitled to is clamped up to the session's ceiling, so a peer cannot lift its own traffic above its admitted priority by lying in the `casc` traffic-class byte. An unknown session falls back to class 128, the worst possible, so unrecognized traffic can never claim priority. This is the per-session enforcement point behind the priority-load-shedding model in [[codel-send-buffer-shedding]]; the `bestTrafficClass` value is also a persisted field of the session state.

## Send-only key persistence (disk-loaded sessions cannot decrypt)

```go
// Cache it (sendKey is stored as SessionKey; recvKey is not persisted
// in the current schema, so sessions loaded from disk cannot decrypt
// incoming traffic. This is acceptable because sessions are short-lived
// and the cache is the primary path.)
cached := &cachedSession{
	sendKey: state.SessionKey,
	recvKey: state.SessionKey, // fallback: same key (will fail for Noise sessions loaded from disk)
	...
}
```

The persisted session schema (`casksessiontable.SessionState`) holds a single `SessionKey`, set to the session's `sendKey`. The directional `recvKey` is **not** persisted. A session reloaded from disk therefore sets `recvKey = sendKey` as a fallback, which is wrong for a Noise session (the two directional keys differ), so a disk-loaded Noise session can encrypt but cannot decrypt incoming traffic. The comment states the rationale explicitly: this is acceptable because sessions are short-lived (TTL-bounded) and the in-memory cache is the primary path; a session that has fallen out of cache has effectively expired. This is a known single-key-schema limitation, not an oversight, and a candidate note for any future schema that wants disk-resumable bidirectional sessions.

Source: [net/crypto.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/crypto.go) at commit `cdb975d8` (lines 68-352).
