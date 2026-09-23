---
title: Stage 0 — connect, op:start-session, op:abort, netlayers
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: Crossed-hellos mitigation by session-ID sort + abort-lower is canonical and recurs across CapTP-family implementations. The `my-location` record wrapper for signing is a specific defense against context-confusion attacks (the doc cites the sandstorm.io 2015-05-01 post on the topic). Soft-flag overlap with ocapn--draft-specifications-captp--* on the same ops.
---

> Abstract: First implementation milestone: get a session up and down. Implementer builds a basic netlayer (the worked example is Tor Onion Services, talking to the Tor control socket — the netlayer hands CapTP `new_outgoing_connection(locator)` and `accept_incoming_connection()`). CapTP exchanges `op:start-session` records carrying a captp-version string, a freshly generated session-pubkey (never reused), an acceptable-location (OCapN reference), and a signature over the location wrapped in a `my-location` record (context-confusion mitigation). The implementer maintains two tables: active sessions (remote-location → session) and outgoing sessions (outgoing-location → keypair). The outgoing table mitigates the "crossed hellos" problem: when both sides open simultaneously, both sessions compute IDs (sort+hash of the pubkeys) and abort the lower-ID session. `op:abort` carries an implementation-defined reason string.

### Stage 0: connect, op:start-session, op:abort + netlayers ("laying the foundation")

Alisha wants to connect to her friends Ben and Carol who are already on the OCapN network and also wants to begin programming her own implementation of OCapN in the process. In order to connect to her friends' peers on the network, she must first bootstrap her connection.

In this stage we cover:

- Implementing a very basic netlayer
- OCapN peer locators
- Starting the session with `op:start-session`
- Terminating the session with `op:abort`

#### Implementing a basic netlayer

Netlayers are just a channel between two "peers" which speak CapTP. These peers could be on the same virtual or physical machine, same local network, or on the other side of the world. Netlayers are designed to abstract away the logistics of sending and delivering messages away from CapTP and provide an agnostic concept of a channel which is a bidirectional FIFO. Thus CapTP is itself agnostic to the underlying network protocol, with individual netlayers providing different characteristics around latency, liveness, privacy, and general mechanism.

Every netlayer ultimately provides a bidirectional channel between two peers on the network. Alisha both needs to be able to accept connections from the network and to open outgoing connections to other peers. In both cases, the netlayer ultimately hands to CapTP a mechanism for receiving and being informed of new messages and a mechanism for sending messages.

Alisha decides to implement the Tor Onion Services netlayer as a first step. To do this she implements her netlayer to talk to the Tor control socket both registering her process to be able to accept new connections for a particular network identity and adds control code for making outgoing connections also speaking through the control socket. When the netlayer is instantiated and configured, it provides two functions:

- `new_outgoing_connection(ocapn_locator)`: speaks to the Tor daemon to open a new connection to the specified OCapN locator and returns a socket for read/write.
- `accept_incoming_connection()`: waits for a new incoming connection to her peer and returns it. She'll need to hook this up to run in its own thread.

#### Starting and terminating sessions

Once a new connection has been established by the netlayer, the netlayer hands the rest of the work over to the CapTP implementation to complete configuring an active session.

CapTP needs to ensure that only a single active session exists between two peers addressable on the network. This prevents unnecessarily opening many duplicate connections, permits reusing the same live object references when referring to the same live objects, and permits assertions that two objects that have the same object identity also have same live reference identity.

The first messages exchanged over a CapTP session are to initialize the CapTP session. This is done with the `op:start-session` message:

```
<op:start-session captp-version             ; String value
                  session-pubkey            ; CapTP public key value
                  acceptable-location       ; OCapN Reference type
                  acceptable-location-sig>  ; CapTP signature
```

This message includes several important pieces of information:

- The message establishes which version of OCapN's CapTP is being used, ensuring that both sides are speaking a compatible revision of the protocol.
- The `session-pubkey` is encoded public-key cryptographic information used for signatures. This key is always part of a freshly generated keypair which is **never reused** outside of this particular session. It is used for:
  - Creating a distinct identifier for this side of the session.
  - Creating a distinct identifier for identifying the session as a whole, created by sorting, combining, and hashing both sides' pubkeys.
  - Performing signature verification for third-party handoffs.
- The `acceptable-location` is used to perform handoffs and to identify the peer in a unique way so only one connection is opened to a given peer.
- The `acceptable-location-sig` allows the peer to demonstrate to us that it controls the private key part to the public key specified in `session-pubkey`.

Alisha generates a keypair, formats the public key for the `op:start-session` message, and signs her `acceptable-location` wrapped within a `my-location` record. (The wrapping prevents context-confusion vulnerabilities — see the [sandstorm.io 2015-05-01 post](https://sandstorm.io/news/2015-05-01-is-that-ascii-or-protobuf) on protobuf vs ascii signing-context confusion.)

A concrete `op:start-session` message looks like:

```
<op:start-session "1.0"
                  (public-key (ecc (curve Ed25519) (flags eddsa) (q ...) (s ...)))
                  (ocapn-peer "..." 'onion #f)
                  (sig-val (eddsa (r ...) (s ...)))>
```

Alisha transmits this message to the other side and reads on the channel looking for the remote peer's own `op:start-session`. She verifies that the `acceptable-location-sig` signs the `acceptable-location` wrapped within a `my-location` record, using the other side's `session-pubkey`.

She maintains two tables to track sessions:

- **Active sessions**: remote location → session. Used to reuse already-established sessions.
- **Outgoing sessions**: outgoing location → keypair. Used to mitigate the *crossed hellos* problem (when both peers initiate at the same time).

When an incoming connection arrives, she checks if she is currently in the middle of initiating an outgoing session to the same peer. If so, both sides compute a session ID (sort + hash the pubkeys per the CapTP specification), sort the serialized IDs, and abort the lower of the two sessions.

The abort message:

```
<op:abort reason>  ; reason: String
```

In the crossed-hellos case the abort reason might be `"Crossed hellos mitigated"`; the spec leaves the text up to the implementation.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
