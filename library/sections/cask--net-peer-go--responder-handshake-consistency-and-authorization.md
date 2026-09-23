---
title: Responder handshake — ed25519↔x25519 consistency check, member-table authorization, and responder mutual membership
source: net/peer.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "1727-1828"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How Server.handleInit processes Noise IK message 1 on the responder side — verifying that the initiator's ed25519 identity key converts to the x25519 key the Noise handshake revealed, gating on the member table with statusNotAuthorized, capping the TTL, writing message 2, and adding the initiator to its own member table for mutual membership
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking, capability-security]
status: current
supersedes: []
notes: |
  Responder-side counterpart to cask--net-peer-go--session-renewal-single-flight
  (which covered the initiator side). Cross-references noise-ik-session-
  establishment (the handshake), member-table-authorization (the authorization
  gate and mutual MemberAdd), and the ed25519↔x25519 conversion documented in
  cask--net-noise-go--ed25519-x25519-key-conversion. Restates none of them; this
  section is the responder's orchestration around the handshake. Carries the
  cycle-16 TODO drift item (handleInit hardcodes DefaultBestTrafficClass) as a
  known unfinished feature, not stale comment.
---

> Abstract: `Server.handleInit` is the responder side of the casknet Noise IK handshake, the symmetric counterpart to the initiator's `ensureSession`/`establishSession`. It parses the init packet, generates a fresh ephemeral x25519 keypair, and runs Noise IK message 1 through a `NoiseIKResponder`, which reveals the initiator's static x25519 public key. The handshake payload also carries the initiator's **ed25519 identity key**, and `handleInit` performs a **consistency check**: the ed25519 key must convert (via the birational map) to exactly the x25519 key the Noise handshake revealed, otherwise the packet is rejected with `statusAuthFailed`. It then applies the **authorization gate** — if a `MemberLookup` is configured and the initiator's ed25519 key is not in the member table, it rejects with `statusNotAuthorized` — caps the granted TTL at 24 hours, writes Noise message 2 (status + responder ed25519 key), creates a server-role session with directional keys, and performs the **responder side of mutual membership** by adding the initiator's ed25519 key to its own member table so future sessions in either direction are authorized. The traffic class for the new session is currently hardcoded to `DefaultBestTrafficClass` behind an explicit TODO to look the member's best class up from the member table.

This section is the responder counterpart to the initiator-side [session-renewal-single-flight](cask--net-peer-go--session-renewal-single-flight.md). It does not restate the Noise IK handshake (see [[noise-ik-session-establishment]] and [cask--net-noise-go--noise-ik-handshake-state-machine](cask--net-noise-go--noise-ik-handshake-state-machine.md)), the member-table model (see [[member-table-authorization]]), or the key conversion (see [cask--net-noise-go--ed25519-x25519-key-conversion](cask--net-noise-go--ed25519-x25519-key-conversion.md)); it covers the responder's orchestration around all three.

## ed25519↔x25519 consistency check

The Noise IK handshake reveals the initiator's static x25519 public key; the init payload independently carries the initiator's ed25519 identity key. `handleInit` requires the two to agree:

```go
// The payload contains: ed25519_pub (32B) || timestamp (8B).
// Extract the initiator's ed25519 public key.
var initiatorEd25519 ed25519.PublicKey
if len(payload) >= 32 {
	initiatorEd25519 = ed25519.PublicKey(payload[:32])

	// Verify consistency: the ed25519 key should convert to the x25519
	// key revealed by the Noise handshake.
	expectedX25519, convErr := Ed25519PublicToX25519(initiatorEd25519)
	if convErr != nil || expectedX25519 != initiatorX25519Pub {
		reject := buildInitResponseReject(sessionID, statusAuthFailed)
		_, _ = s.conn.WriteToUDP(reject, remoteAddress)
		return ErrBadHandshake
	}
}
```

This binds the two identity representations: the member table is keyed by **ed25519** identity, but the Diffie-Hellman key agreement is over **x25519**. Without the consistency check an attacker who knew an authorized member's ed25519 public key (it is public) could present it alongside a different x25519 key it actually controls, opening an authorized session under a stolen identity. Requiring `Ed25519PublicToX25519(ed_key) == x_key_from_noise` proves the initiator holds the private key matching the ed25519 identity it claims. The conversion itself is [cask--net-noise-go--ed25519-x25519-key-conversion](cask--net-noise-go--ed25519-x25519-key-conversion.md).

## Authorization gate: statusNotAuthorized

```go
// Authorization: check if the initiator's ed25519 public key is in our
// member table.
if s.Sessions.MemberLookup != nil {
	authorized, lookupErr := s.Sessions.MemberLookup(requestContext, initiatorEd25519)
	if lookupErr != nil {
		return lookupErr
	}
	if !authorized {
		reject := buildInitResponseReject(sessionID, statusNotAuthorized)
		_, _ = s.conn.WriteToUDP(reject, remoteAddress)
		return ErrNotAuthorized
	}
}
```

The gate is conditional on a configured `MemberLookup`; a server without one accepts any consistent identity (the open-membership case). When configured, a non-member is rejected with the plaintext `statusNotAuthorized` status code — distinct from `statusAuthFailed`, so the initiator can tell "your handshake was malformed or your keys were inconsistent" apart from "your identity is valid but you are not a member here." This is gate 1 (membership) of cask's [[cask-three-gate-access|three-gate access model]].

## TTL cap, session creation, and the traffic-class TODO

```go
// Cap TTL at 24 hours.
maxTTL := uint32(24 * 60 * 60)
if ttlSeconds > maxTTL {
	ttlSeconds = maxTTL
}
```

```go
// Create session (server role) with directional keys.
// TODO: look up the member's best traffic class from the member table.
err = s.Sessions.CreateSession(requestContext, sessionID, ttlSeconds, casksessiontable.RoleServer, casksessiontable.ModeMember, casksessiontable.DefaultBestTrafficClass, sendKey, recvKey, remoteAddress)
```

The responder clamps the initiator's requested TTL to a 24-hour ceiling, then writes Noise message 2 (a 33-byte payload of `statusSuccess || responder_ed25519`) and creates a **server-role** session with the directional `sendKey`/`recvKey` the Noise `Split` produced. The `DefaultBestTrafficClass` argument is a known placeholder: the explicit `// TODO` says the session's best traffic class should come from the member table, but that lookup is not yet wired. This is a deliberately unfinished feature (carried forward from the cycle-16 survey), not comment-vs-code drift — the comment correctly describes work not yet done.

## Responder side of mutual membership

```go
// Mutual membership: add the initiator's ed25519 public key to our
// membership table so that future sessions from either direction are
// authorized.
if s.Sessions.MemberAdd != nil && len(initiatorEd25519) == 32 {
	if addErr := s.Sessions.MemberAdd(requestContext, initiatorEd25519); addErr != nil {
		log.Printf("casknet: mutual membership add (responder): %v", addErr)
	}
}
```

This is the mirror of the initiator's `MemberAdd` (documented in [session-renewal-single-flight](cask--net-peer-go--session-renewal-single-flight.md) and from the `crypto.go` side in [cask--net-crypto-go--membership-mutuality-traffic-class-and-key-asymmetry](cask--net-crypto-go--membership-mutuality-traffic-class-and-key-asymmetry.md)). After a successful inbound handshake the responder records the initiator's identity in its own member table, so the relationship is symmetric: once either side completes a handshake, both can open sessions to the other without re-bootstrapping trust. A `MemberAdd` failure is logged but not fatal — the session itself already succeeded — and `MemberAdd` must be idempotent because both directions may add the same pair.

Source: [net/peer.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/peer.go) at commit `cdb975d8` (lines 1727-1828).
