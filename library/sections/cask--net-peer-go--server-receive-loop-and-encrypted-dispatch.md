---
title: Server receive loop and encrypted dispatch — plaintext-handshake vs encrypted-data fork, mobility address update, inner-command switch
source: net/peer.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "1636-1704, 1839-1880"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: How the Server's single read goroutine receives UDP datagrams, forks on the first four bytes between the plaintext init/tini handshake and encrypted data, tracks in-flight handlers for graceful shutdown, suppresses expected replay-detection noise, and how handleEncrypted decrypts, updates the peer address for mobility, and dispatches on the inner command
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
topics: [networking]
status: current
notes: |
  Server-side inbound path of peer.go, the receive counterpart to the Peer's
  outbound machinery (cask--net-peer-go--command-request-span-lifecycle). Cross-
  references casknet-wire-protocol (the reversed-response command set and the
  first-four-bytes detection) and noise-ik-session-establishment (the handshake
  the init/tini branch runs). Restates neither; this section is the receive-loop
  framing around them.
---

> Abstract: a `casknet` `Server` runs a single goroutine that reads UDP datagrams into a fixed 1500-byte buffer and dispatches each one through `handle`. `handle` forks on the **first four bytes**: `init` and `tini` are plaintext session-handshake commands (routed to `handleInit` / `handleInitResponse`), and everything else of at least `minEncryptedPacketSize` is an encrypted data packet routed to `handleEncrypted`. Each `handle` call is wrapped by a `handleWg` wait-group so `Stop` can drain in-flight handlers gracefully, and the read loop exits cleanly when the connection is closed (detected by the `"use of closed network connection"` error string). The loop deliberately **does not log `ErrReplayDetected`** at the same level as real errors, because reordered UDP packets routinely trip replay detection. `handleEncrypted` decrypts the packet against the session manager, then **updates the peer's address for mobility support** (`UpdatePeerAddr`, so a peer that roamed to a new IP/port keeps its session), and finally dispatches on the inner 4-byte command (`load`/`stor`/`rots`/`casc`/`csac`/`gcgc`/`cgcg`/`mass`/`ssam`) to the matching `handle*` method.

This section carries the Server's inbound receive loop and encrypted-dispatch fork. It does not restate the command vocabulary (see [[casknet-wire-protocol]]) or the handshake the init/tini branch runs (see [[noise-ik-session-establishment]]); it covers the loop and dispatch framing around them. The responder-side `handleInit` body has its own section ([responder-handshake-consistency-and-authorization](cask--net-peer-go--responder-handshake-consistency-and-authorization.md)).

## The read loop and graceful-shutdown tracking

`Start` binds the UDP socket and launches one goroutine over a fixed buffer:

```go
// Start opens a connection for sending and receiving messages.
//
// Start blocks until the listening port is available and then
// handles incoming messages in the background.
```

```go
var buffer [1500]byte
for {
	n, remoteAddress, err := conn.ReadFromUDP(buffer[:])
	if err != nil {
		// Exit the loop when the connection is closed (by Stop()).
		// Check for "use of closed network connection" error.
		if strings.Contains(err.Error(), "use of closed network connection") {
			return
		}
		log.Printf("%s\n", err)
		continue
	}
	// Track in-flight handle calls for graceful shutdown.
	s.handleWg.Add(1)
	if err := s.handle(remoteAddress, buffer[:n]); err != nil {
		// Replay detection is expected for reordered UDP packets;
		// don't log it at the same level as real errors.
		if !errors.Is(err, ErrReplayDetected) {
			log.Printf("%s\n", err)
		}
	}
	s.handleWg.Done()
}
```

Two robustness notes ride in the comments. First, the read loop's only clean exit is the closed-connection case, which `Stop` triggers; any other read error is logged and the loop continues rather than tearing down the server. Second, `ErrReplayDetected` is filtered out of the error log because reordered UDP datagrams routinely trip the per-direction monotonic-counter replay check (see [[casknet-wire-protocol]] and the `net/crypto.go` counter-nonce implementation); logging it as an error would drown real failures in expected noise. The single buffer is reused per iteration, and `handle` is called synchronously, so one datagram is fully processed before the next is read.

## The plaintext-vs-encrypted fork

`handle` discriminates on the first four bytes:

```go
// Session handshake commands are plaintext.
switch string(buffer[0:4]) {
case commandINIT:
	return s.handleInit(requestContext, buffer, remoteAddress)
case commandTINI:
	return s.handleInitResponse(requestContext, buffer, remoteAddress)
}

// All other traffic is encrypted.
if s.Sessions != nil && len(buffer) >= minEncryptedPacketSize {
	return s.handleEncrypted(requestContext, buffer, remoteAddress)
}
```

Only `init` and `tini` are plaintext, because the handshake is what establishes the keys; every other command rides inside an encrypted envelope and is only dispatched when a session manager is configured and the datagram is at least `minEncryptedPacketSize` long. A datagram shorter than four bytes is rejected as `corrupt message`.

## handleEncrypted: decrypt, mobility update, inner dispatch

```go
// Decrypt the packet
sessionID, plaintext, err := s.Sessions.Decrypt(requestContext, buffer)
if err != nil {
	return err
}

// Update peer address (mobility support)
s.Sessions.UpdatePeerAddr(sessionID, remoteAddress)

// Dispatch based on inner command
if len(plaintext) < 4 {
	return ErrPacketTooShort
}

switch string(plaintext[0:4]) {
case commandLOAD:
	return s.handleLoad(requestContext, plaintext, sessionID, remoteAddress)
case commandSTOR:
	return s.handleStore(requestContext, plaintext, sessionID, remoteAddress)
// ... rots / casc / csac / gcgc / cgcg / mass / ssam ...
default:
	return ErrUnknownCommand
}
```

The decrypt step both authenticates the packet (a failed AEAD tag or a replayed counter returns an error) and recovers the session ID. The **mobility update** is the notable design point: after a successful decrypt, the server records `remoteAddress` as the session's current peer address, so a peer that moved to a new IP or port (a laptop changing networks, a NAT rebinding) continues to receive responses at its new address without re-handshaking. The decrypted inner command is then routed by the same reversed-response 4-byte code the outbound side built, completing the symmetry with the `Peer`'s send path.

Source: [net/peer.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/net/peer.go) at commit `cdb975d8` (lines 1636-1704, 1839-1880).
