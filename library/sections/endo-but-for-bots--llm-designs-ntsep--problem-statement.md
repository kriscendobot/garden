---
title: Problem statement (network/transport conflation in OCapN today)
source: designs/ocapn-network-transport-separation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: The four problems are the load-bearing motivation for the refactor. Item 1 (noise supporting multiple transports) is the OCapN-Noise driver. Item 3 (handshake baked into core, but noise piggybacks its own) is the structural blocker.
---

> Abstract: OCapN today conflates "network" with "transport". The `OcapnLocation.transport` field (e.g., `'tcp-testing-only'`) simultaneously identifies a protocol family AND how to physically connect. `packages/ocapn/src/client/index.js`'s `netlayers` map is keyed by transport name; `establishSession` looks up netlayers by `location.transport`. Four concrete problems: (1) a network like OCapN-Noise that supports WebSocket + TCP+Netstring + Tor must register each as a separate "netlayer", losing shared identity and session semantics; (2) locators should designate a **network** (the authenticator and session multiplexer), not a transport (the byte carrier); (3) the `op:start-session` handshake in `packages/ocapn/src/client/handshake.js` is OCapN-core-mandated, but OCapN-Noise piggybacks authentication on Noise's handshake and shouldn't be forced through `op:start-session`; (4) crossed-hellos resolution and initiator/responder authenticity should live in the network, not be OCapN's job.

## What is the Problem Being Solved?

OCapN currently conflates the concepts of "network" and "transport". The `OcapnLocation` type has a `transport` field (e.g., `'tcp-testing-only'`) that simultaneously identifies what protocol family a peer belongs to and how to physically connect to it. The `netlayers` map in `packages/ocapn/src/client/index.js` registers implementations by transport name, and the `establishSession` function looks up a netlayer by `location.transport`.

This conflation creates several problems:

1. A network like OCapN-Noise may support multiple transports (WebSocket, TCP with Netstring, Tor) but must register each as a separate "netlayer", losing the shared identity and session semantics of the network.
2. A locator should designate a **network** (the protocol that authenticates and multiplexes sessions) not a **transport** (the byte-stream carrier). The network is what gives a locator its security and identity properties.
3. The `op:start-session` handshake is baked into the OCapN core (`packages/ocapn/src/client/handshake.js`), but different networks need different session negotiation. OCapN-Noise piggybacks authentication on the Noise Protocol handshake and should not be forced through `op:start-session`.
4. OCapN networks should also manage "crossed-hellos" and ensure authenticity of the initiator and responder regardless of whether the local or remote party initiated the session.

Source: [designs/ocapn-network-transport-separation.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-network-transport-separation.md) at commit `0ee0cbb3` on branch `llm`.
