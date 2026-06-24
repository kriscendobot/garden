---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: "The §canonical pattern: two-process simulation via shared-bootstrap"
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

The loopback's architecture is reusable beyond CapTP testing:
the *shared-bootstrap + nonce-keyed ref-table + cross-wired
dispatch* pattern is the standard way to *test a distributed
protocol in-process*. The §test-the-distributed-protocol-in-
process discipline names:

- **Two endpoints** that *believe* they're remote (so they
  exercise the wire format).
- **Cross-wired dispatch** so messages flow between them.
- **Shared bootstrap** for handshake / introductory refs.
- **Nonce-based ref-passing** so test code can hand specific
  values to specific sides.

§distributed-protocol-test-fixture-as-genre.
