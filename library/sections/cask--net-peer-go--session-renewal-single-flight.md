---
title: Session renewal — single-flight handshake, retransmit-until-timeout, and mutual membership
source: net/peer.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "1191-1340, 1432-1483"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How ensureSession serializes concurrent callers so only one performs the Noise IK handshake while the rest wait, how it renews a session before expiry, how establishSession retransmits the init packet over unreliable UDP until a response or timeout, and how the initiator adds the responder to its member table after a successful handshake
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking, capability-security]
status: current
notes: |
  Initiator-side session lifecycle in peer.go. Cross-references
  noise-ik-session-establishment (the handshake itself, in noise.go/crypto.go)
  and member-table-authorization (the MemberAdd mutual-membership step, whose
  implementation note also appears in cask--net-crypto-go). Restates neither;
  this section is the orchestration around the handshake, not the handshake.
  Responder-side handleInit (ed25519<->x25519 consistency check, authorization,
  responder MemberAdd) is deferred to a follow-on cycle.
---

> Abstract: a `Peer` lazily establishes and renews its encrypted session through `ensureSession`, which every public operation calls first. `ensureSession` is **single-flight**: if a valid session exists and is not within its renewal margin of expiry, it returns the cached session ID immediately; otherwise exactly one goroutine sets `sessionEstablishing = true`, runs the handshake, and closes `sessionEstablishDone`, while every other concurrent caller waits on that channel and then retries. Renewal is proactive — a session is re-established once `now` passes `sessionExpiry − sessionRenewalMargin` (default margin one minute, default TTL one hour), so a session is replaced before it lapses rather than after a failure. The handshake itself, `establishSession`, builds [[noise-ik-session-establishment|Noise IK]] message 1 (inner payload `ed25519_pub (32) || timestamp (8)`), sends the init packet, and **retransmits every 500 ms until a response arrives or a 10 s total timeout** because UDP is unreliable. On success it derives directional transport keys from Noise message 2, creates the client-role session, and — the implementation-only step — adds the responder's ed25519 key to its own [[member-table-authorization|member table]] so future sessions in either direction are authorized.

This section carries the initiator-side session-lifecycle comments. It does **not** restate the Noise IK handshake (see [[noise-ik-session-establishment]] and the design-doc sources [cask--net-crypto](cask--net-crypto.md) / [cask--net-session-init-design](cask--net-session-init-design.md)) or the member-table model ([[member-table-authorization]]); it covers the orchestration around them. The responder side (`Server.handleInit`) is deferred to a follow-on cycle.

## ensureSession is single-flight

```go
// ensureSession checks that a valid, non-expiring session exists with the peer.
// If no session exists or the current session is about to expire, it establishes
// a new one. Multiple concurrent callers are serialized: only one performs the
// handshake while the others wait.
```

The serialization uses a boolean flag plus a completion channel, both under `p.mu`:

```go
if p.sessionEstablishing {
	ch := p.sessionEstablishDone
	p.mu.Unlock()
	select {
	case <-ch:
		continue          // handshake done — re-check from the top
	case <-ctx.Done():
		return cask.Hash{}, ctx.Err()
	}
}
// We are the goroutine that will perform the handshake.
p.sessionEstablishing = true
p.sessionEstablishDone = make(chan struct{})
```

A waiter that wakes does not assume the in-flight handshake succeeded; it `continue`s the outer `for` and re-evaluates the cached-session test, so a failed handshake simply leaves the next caller to try again (or to observe the same error). The goroutine that ran the handshake clears `sessionEstablishing` and closes `sessionEstablishDone` in all cases, success or error, so waiters are never stranded.

## Proactive renewal before expiry

```go
if p.sessionEstablished && time.Now().Before(p.sessionExpiry.Add(-p.sessionRenewalMargin())) {
	id := p.sessionID
	p.mu.Unlock()
	return id, nil
}
```

The cached session is reused only if `now` is before `sessionExpiry − sessionRenewalMargin`. `sessionTTL` defaults to one hour and `sessionRenewalMargin` to one minute (both configurable), so a session is re-established in the last minute of its life. Renewing ahead of expiry avoids a window where a fresh `Store` would encrypt under a session the remote has already discarded.

## establishSession retransmits over unreliable UDP

```go
// establishSession establishes an encrypted session with the peer using Noise IK.
// Called internally by ensureSession; callers should use ensureSession instead.
// Retransmits the init packet periodically until a response is received or
// the timeout expires.
```

The two constants bound the handshake:

```go
const sessionInitTimeout = 10 * time.Second        // total time allowed
const sessionInitRetryInterval = 500 * time.Millisecond  // retransmit cadence
```

`establishSession` sends the init packet once, then enters a `select` over three cases: the response channel (success or a status-coded failure such as `statusAuthFailed` / `statusNotAuthorized`), a 500 ms retry ticker that re-sends the **same** init packet (`// Retransmit the init packet (UDP is unreliable).`), and the 10 s timeout. Re-sending the identical packet is safe because session establishment is idempotent on the responder until the session is created. On a successful response it completes the Noise handshake by reading message 2, deriving `sendKey` / `recvKey`, and creating the client-role session.

## Mutual membership: the initiator adds the responder

```go
// Mutual membership: add the responder's ed25519 public key
// to our membership table so that future sessions from either
// direction are authorized.
if p.server.Sessions.MemberAdd != nil && len(responderEd25519) == 32 {
	if addErr := p.server.Sessions.MemberAdd(ctx, responderEd25519); addErr != nil {
		log.Printf("casknet: mutual membership add (initiator): %v", addErr)
	}
}
```

After a node successfully initiates a session, it records the responder's ed25519 identity in its own member table. Combined with the symmetric step on the responder side (`Server.handleInit`, deferred to a follow-on), this is the **mutual-membership** invariant: a completed handshake authorizes future sessions in *either* direction, so the relationship does not have to be re-bootstrapped when the roles swap. This is one of the implementation-only design notes the [`cask--net-crypto-go` membership section](cask--net-crypto-go--membership-mutuality-traffic-class-and-key-asymmetry.md) also documents from the `crypto.go` side; the policy lives in [[member-table-authorization]]. A `MemberAdd` failure is logged but not fatal — the session itself already succeeded.

Source: [net/peer.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/peer.go) at commit `cdb975d8` (lines 1191-1340, 1432-1483).
