---
title: Overview + np: identifier
source: designs/ocapn-noise-network.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: The four gaps named here drive the whole network-transport-separation effort: today's `@endo/ocapn-noise` provides cryptographic bindings but no network layer; this design supplies one. The `designator` derivation (double-SHA256 of the serialized Ed25519 public-key descriptor) matches the existing Public-Identifier rule used elsewhere in CapTP.
kind: index
section_count: 1
---

> Abstract: `@endo/ocapn-noise` (v0.1.0) provides Noise Protocol bindings (handshake primitives `asInitiator`/`asResponder`, encrypt/decrypt) but **no OCapN network**. Four gaps: (1) no `OcapnNetwork` implementation that plugs into the OCapN client; (2) no transport layer abstraction (no WebSocket or TCP transport); (3) the handshake is coupled to raw byte arrays with no transport framing; (4) connection hints don't encode transport selection. The design fills these by making OCapN-Noise a proper network designated by `"np"`, with pluggable transports and the OcapnNetwork interface. Locator examples: `ocapn://<designator>.np?ws:host=example.com&ws:port=443` and `ocapn://<designator>.np?tcp:host=127.0.0.1&tcp:port=9000`. The `designator` is derived from the node's Ed25519 public key (double-SHA256 hash of the serialized public-key descriptor — same rule used by Public-Identifier elsewhere in CapTP).

Sections:

- [What is the Problem Being Solved?](endo-but-for-bots--llm-designs-ocapn-noise-network--overview-and-identifier--what-is-the-problem-being-solved.md)

Source: [designs/ocapn-noise-network.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-noise-network.md) at commit `0ee0cbb3` on branch `llm`.
