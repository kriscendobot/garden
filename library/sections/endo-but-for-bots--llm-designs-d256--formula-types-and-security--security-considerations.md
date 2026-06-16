---
title: Security considerations
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-d256--formula-types-and-security
---

| Concern | Resolution |
|---|---|
| **256-bit random** | Provides 2^256 collision resistance; birthday-bound 2^128 attempts to find a collision exceeds any conceivable adversary's computational capacity. |
| **SHA-256** | 128-bit security against collision attacks (birthday bound); 256-bit security against preimage attacks. Adequate for content addressing where an attacker would need a collision to substitute malicious content. |
| **Ed25519** | 128-bit security level. Public key is the permanent identifier; private key authenticates during OCapN-Noise handshakes. Signatures are deterministic — no nonce-reuse vulnerability. |
| **Migration weakening?** | None. 256-bit security is considered safe against quantum computers with Grover's algorithm (Grover gives effective 128-bit security against 256-bit primitives). |

The asymmetry between the *128-bit-effective* security of the
primitives (under birthday or Grover attacks) and the *256-bit*
identifier length is intentional: the identifier length is set by
*peer-key alignment with Ed25519*, not by a target security level.
The 128-bit effective security is the floor; the 256-bit length is
what aligns with the protocol layer.
