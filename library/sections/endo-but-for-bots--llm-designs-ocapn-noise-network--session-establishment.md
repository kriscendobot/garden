---
title: Session establishment (Noise XX handshake replaces op:start-session)
source: designs/ocapn-noise-network.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp, capability-security]
status: current
notes: This is the load-bearing claim of the design: the Noise XX handshake provides everything op:start-session provides (mutual auth, key agreement, peer identification) plus encryption and encoding negotiation, in one round-trip-pair (SYN/SYNACK/ACK). The intended-responder-key prefix on SYN is the mis-direction defense — without it, a forwarded SYN could be processed by a different peer.
---

> Abstract: **The Noise handshake replaces `op:start-session` entirely.** Five-step flow: (1) **Initiator** opens a byte stream via the selected transport; (2) **Initiator** writes SYN (164 bytes: intended responder's Ed25519 public key (32 bytes) + Noise XX first message (132 bytes)); (3) **Responder** reads SYN, verifies it's for them, writes SYNACK (193 bytes: responder's Ed25519 key, encoding negotiation, signature); (4) **Initiator** reads SYNACK, verifies responder identity + signature, writes ACK (64 bytes); (5) both sides now have `encrypt`/`decrypt` (ChaCha20-Poly1305); the `NetworkSession` is delivered to OCapN core and subsequent CapTP messages are encrypted. **No op:start-session** is sent — the Noise handshake provides mutual authentication (Ed25519-key possession), key agreement (ephemeral x25519), encryption (ChaCha20-Poly1305), and encoding negotiation (piggybacked on SYNACK).

### Session Establishment

The Noise handshake replaces `op:start-session` entirely:

1. **Initiator** opens a byte stream via the selected transport.
2. **Initiator** writes the SYN message (164 bytes): intended responder's Ed25519 public key (32 bytes) + Noise XX first message (132 bytes).
3. **Responder** reads SYN, verifies it's intended for them, writes SYNACK (193 bytes): contains responder's Ed25519 public key, encoding negotiation, signature.
4. **Initiator** reads SYNACK, verifies responder identity and signature, writes ACK (64 bytes).
5. Both sides now have `encrypt` and `decrypt` functions (ChaCha20-Poly1305).
6. The `NetworkSession` is delivered to OCapN core. All subsequent CapTP messages are encrypted.

No `op:start-session` is sent. The Noise handshake provides:

- Mutual authentication (both parties prove possession of their Ed25519 keys).
- Key agreement (ephemeral x25519 keys negotiated by Noise).
- Encryption (ChaCha20-Poly1305 from the Noise session).
- Encoding negotiation (piggybacked on SYNACK per current implementation).

Source: [designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
