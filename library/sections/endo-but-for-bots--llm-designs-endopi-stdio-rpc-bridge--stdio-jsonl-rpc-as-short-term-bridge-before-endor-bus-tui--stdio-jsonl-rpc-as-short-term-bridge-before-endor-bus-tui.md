---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: Stdio JSONL RPC as short-term bridge before endor-bus-tui
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

> *The maintainer's `endor-bus-tui` direction eventually subsumes
> some of this, but on a multi-quarter horizon. The short-term gap
> is real: a stdio JSONL surface that gives an embedding host the
> same affordances the WebSocket gateway gives the browser.*
>
> — `designs/endopi-stdio-rpc-bridge.md` §Motivation

`endopi-stdio-rpc-bridge.md` (149 lines, *Proposed* status, created
2026-05-15) is the sixth endopi-* design ingested and the fourth
spinout from cycle 121's family keystone. Parent: `endopi.md`. The
design closes the §Operating modes gap surfaced by cycle 121's
keystone: *Pi's RPC mode is the part Endo does not have — a strict
line-delimited JSON protocol for embedding the agent in another
process (an IDE, a CI harness, a Familiar pane) without WebSocket
overhead*.
