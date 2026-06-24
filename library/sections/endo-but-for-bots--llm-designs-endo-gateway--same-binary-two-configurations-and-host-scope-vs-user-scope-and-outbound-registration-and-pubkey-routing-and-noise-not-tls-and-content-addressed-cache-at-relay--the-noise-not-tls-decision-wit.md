---
title: §the-Noise-not-TLS decision, with three named consequences (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
source-slug: endo-but-for-bots--llm-designs-endo-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-gateway.md
authors: [Kris Kowal (prompted)]
status: Proposed
created: 2026-05-10
updated: 2026-05-10
ingest-cycle: 283
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 997
parent: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
---

The Gateway does **not** terminate TLS at any layer. **Session-level confidentiality and peer authentication for OCapN are provided by the Noise Protocol netlayer** described in `ocapn-network-transport-separation`: once the WebSocket handshake at `/ocapn` completes, the OCapN session begins with a Noise handshake whose static keys are the Ed25519 keys that double as OCapN node identifiers. After the handshake, OCapN frames are encrypted and authenticated end-to-end between the remote peer and the User Daemon; **the Gateway, sitting in the middle, sees only ciphertext**.

**Three named consequences worth pinning**:

1. **No certificate management.** The Gateway has no key/cert files, no ACME client, no rotation tooling, and no configuration knobs for cipher suites or SNI.
2. **Authentication is by Ed25519 public key, not by hostname.** The Gateway never claims to be a particular host on a CA-signed certificate; the remote peer authenticates the destination User Daemon by its public key during the Noise handshake.
3. **Browsers are out of scope for the OCapN endpoint.** The OCapN endpoint at `ws://<host>/ocapn` is for OCapN clients (other Endo daemons, the CLI, peer hosts), not for browsers. The browser-facing path is per-weblet HTTP/WebSocket on the weblet's virtual host, which is plain HTTP.

**§three-named-consequences-of-cryptographic-protocol-choice pattern** (first-explicit-observation): the design pre-empts the reader's "but how do you handle TLS / certs / browser-TLS" by enumerating the three named consequences before the reader can object.
