---
title: Scaling Considerations
source: designs/ocapn-noise-network.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, repository-governance]
status: current
notes: The 65535-16=65519 byte limit on encrypted messages (ChaCha20-Poly1305 with 16-byte auth tag) is a hard upper bound on a single Noise-framed message — larger OCapN messages must be chunked. This is a load-bearing constraint that any consumer of @endo/ocapn-noise must respect. The cross-network test (np vs tcp-for-test) is the canonical "incompatible handshakes don't accidentally connect" assertion.
parent: endo-but-for-bots--llm-designs-ocapn-noise-network--package-structure-and-security
---

- Each transport listener is a separate server socket. Running multiple transports multiplies the number of listening ports.
- The Noise handshake adds 3 round-trips (SYN, SYNACK, ACK) before CapTP messages can flow. This is comparable to TLS.
- Encryption/decryption overhead is minimal (ChaCha20-Poly1305 is fast).

Source: [designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
