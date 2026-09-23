---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: The *stdio vs WebSocket as two transports to the same daemon*
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

worldview

The §Relationship to the WebSocket gateway subsection is the
design's most structurally interesting claim:

> *The stdio surface and the WebSocket gateway are two transports
> to the same underlying daemon agent. A guest that has an open
> chat session in the browser can also be reached over stdio; the
> two transports interleave through the same transcript.*

This is the *transport-agnostic-agent* discipline. The agent's
identity, state, and transcript live in the daemon; transports
(WebSocket, stdio, future endor-bus) are *separate access surfaces
to the same identity*. The §Capability shape paragraph reinforces:

> *The embedded agent has the same capability grants as a chat-
> side guest of the same name. The host that spawns `endo agent
> rpc` chooses the guest; the daemon's capability boundaries
> enforce what the agent can do, independent of how it was
> invoked.*

The *capability-bounds-independent-of-transport* invariant means
the security model holds across all access surfaces — cycle 119's
capability-bus discipline applied at the transport layer.
