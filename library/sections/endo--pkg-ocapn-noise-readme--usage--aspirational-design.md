---
title: Aspirational Design
source: packages/ocapn-noise/README.md
source_repo: endojs/endo
source_commit: a1de705b
source_date: 2025-12-31
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn]
status: current
parent: endo--pkg-ocapn-noise-readme--usage
---

The OCapN JavaScript netlayer interface is intended to be as near to platform-
neutral as possible and makes extensive use of language level utilities like
promises and async iterators in order to avoid coupling to platform-specific
features like event emitters or event targets.

This OCapN Noise Protocol netlayer is also intended to stand atop multiple
transport layers, but particularly WebSocket.
Having a single cryptography over multiple transport protocols allows this
OCapN netlayer to preserve the identities of message targets regardless of what
transport capabilities are available on various platforms, such that client,
server, cloud, edge, and any other kind of peer can join the network.

Source: [packages/ocapn-noise/README.md](https://github.com/endojs/endo/blob/a1de705b/packages/ocapn-noise/README.md) at commit `a1de705b`.
