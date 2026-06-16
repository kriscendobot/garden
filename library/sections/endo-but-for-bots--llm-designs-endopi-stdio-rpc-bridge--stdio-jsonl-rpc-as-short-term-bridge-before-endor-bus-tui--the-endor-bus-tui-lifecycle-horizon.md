---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: The §endor-bus-tui lifecycle horizon
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

The §Relationship to `endor-bus-tui` subsection names this
design's *short-term-bridge* lifecycle:

> *The Rust `endor` daemon will, in time, host its own protocol
> over a Unix-socket bus. That bus is the production-shape
> replacement for stdio. The stdio bridge in this design is the
> short-term shape that works on the Node daemon today; once
> `endor` has Bus-TUI parity, the stdio bridge becomes a thin
> front-end for the bus.*

The §thin-front-end-for-the-bus role is the *deprecation-in-place*
discipline: the design ships now to close the gap, with the
explicit understanding that it will *become a wrapper around the
canonical transport* rather than be removed. Cycle 119's
capability-bus design provides the broader frame: the endor binary
hosts *both* the daemon (the message router) and a Unix-socket-
based protocol — that bus is the production transport. This
design's stdio surface bridges the gap between the Node-daemon
present and the endor-bus future.
