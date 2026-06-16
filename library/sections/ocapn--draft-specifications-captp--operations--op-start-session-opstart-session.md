---
title: "[`op:start-session`](#opstart-session)"
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: 9 H2 ops consolidated into one section. op:start-session, op:deliver, op:abort, op:listen, op:get, op:index, op:untag, op:gc-exports, op:gc-answers. Each is independently looked-up-able by the H2 anchor within the consolidated body.
parent: ocapn--draft-specifications-captp--operations
---

When setting up a new session, a EdDSA key pair should be generated.

This operation is used when a new session is initiated over CapTP. Both
parties MUST send an `op:start-session` message upon a new session. The
operation looks like this:

```text
<op:start-session captp-version             ; String value
                  session-pubkey            ; CapTP public key value
                  acceptable-location       ; OCapN Reference type
                  acceptable-location-sig>  ; CapTP signature
```

An important aspect of CapTP is that only one active session between two peers
should exist. This allows peers to perform equality checks against objects from
a remote peer and prevents [3rd Party Handoffs](#third-party-handoffs) when the
receiver and exporter are on the same peer.

There are several mechanisms put in place to ensure that only one session exists
between two peers. The first is that a CapTP implementation MUST check if it has
an active session with a given peer, before trying to establish a new
connection. If the peer already has an active session, that session MUST be used
instead of creating a new one.

### Constructing and sending

The `captp-version` MUST be `1.0`.

The `session-pubkey` is the public key part of the per-session key pair
generated for this connection. This is serialized in accordance with
[Cryptography](#cryptography)

The `acceptable-location` is a OCapN Locator which represents the location where
the session is accessable.

The `acceptable-location-sig` is the signature of the serialized
`acceptable-location`. The signature is created using the private key from the
per-session key pair. This is serialized in accordance with
[Cryptography](#cryptography)

### Receiving

If the session has already received an `op:start-session`, the session MUST be
aborted.

The `captp-version` MUST be equal to `1.0`. If the version does not match, the
connection MUST be aborted.

The `acceptable-location-sig` MUST be valid that the `session-pubkey` provided a
valid signature of `acceptable-location`.

The implementation should check if an active valid session already exists
between the two peers, if one does exist the new session should be aborted.

Detection and (if needed) mitigation of the Crossed Hellos problem described
below MUST be performed.

### Crossed Hellos Resolution

Crossed hellos is a race condition which occurs when two peers attempt to open a
new session to one another simultaneously. If both sessions were to succeed
the result would be multiple sessions between the same peers. Since this is
not permitted in CapTP, all implementations are responsible for detecting and
resolving the problem.

Implementations are responsible for keeping track the sessions they've
initiated. After receiving the `op:start-session` message from the other side,
the receiving side should check to see if it has a session it has opened with
the peer located at the `acceptable-location` provided. If it both received a
session from a peer that it has also opened a session to, the crossed hellos
problem has been detected and must be resolved.

The way to resolve the problem is by choosing which of the two sessions should
be allowed to "win" (and the other to be aborted). This is done by
deterministically calculating the [Public Identifier](#public-identifier) for
its outbound connection and the other side's inbound connection. These two keys
(in their syrup serialization) should be compared bytewise to each other. The
lower of the two has its connection aborted. The higher of the two should
continue to be the valid session for the two peers.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
