---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: CBOR framing — *binary payloads without base64*
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

§CBOR framing notes that the envelope protocol uses CBOR rather than
netstring-framed JSON because CBOR has well-defined byte string
support, making it suitable for passing binary payloads without
base64 encoding. Each frame is a CBOR byte string (major type 2)
wrapping the inner CBOR envelope array.
