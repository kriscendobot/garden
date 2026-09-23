---
title: §Two-framings-for-the-same-CapTP-protocol
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
---

```
For WebSocket connections (gateway and weblet):
  messageToBytes: JSON.stringify → TextEncoder → Uint8Array
  bytesToMessage: Uint8Array → TextDecoder → JSON.parse
  Sent as binary WebSocket frames.

For the UNIX domain socket (CLI):
  same CapTP protocol, framed with netstrings instead of WebSocket frames.
```

§Two-framings-for-the-same-CapTP-protocol. §The-message-payload-format-is-the-same; §the-framing-(WebSocket-binary-frame-vs-netstring)-differs-by-transport.

§Borrowable-pattern: §when-the-same-protocol-runs-over-two-transports, §isolate-the-framing-from-the-payload. §The-CapTP-payload-is-portable; §the-framing-is-transport-specific. §The-design-says-this-explicitly + §implementation-shares-`makeMessageCapTP`-across-both-paths.

§Sibling to cycle 154 trap.js's §narrowed-API-for-narrower-semantics — both designs §parameterize-the-protocol-by-transport-or-call-shape.
