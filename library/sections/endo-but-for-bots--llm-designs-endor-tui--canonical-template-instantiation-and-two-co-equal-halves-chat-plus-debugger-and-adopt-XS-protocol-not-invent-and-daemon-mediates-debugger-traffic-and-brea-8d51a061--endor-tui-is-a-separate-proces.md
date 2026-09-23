---
title: §"endor tui is a separate process, not embedded in the daemon" — three properties
source-slug: endo-but-for-bots--llm-designs-endor-tui
section-slug: canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-daemon-durable
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-tui.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endor-tui.md
source-author: Kris Kowal (prompted)
total-lines: 887
ingest-cycle: 269
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-daemon-durable
---

Design Decision 8 names §three-properties-of-the-process-separation:

1. **Multiple TUIs can attach at once** — §the-bus-IS-multi-client-already + §the-TUI-doesn't-need-to-be-singleton.
2. **A TUI crash cannot take down the daemon** — §process-isolation-IS-a-named-reliability-property + §the-daemon-IS-the-system's-availability-anchor.
3. **Remote operation over SSH works without proxying** — §the-SSH-endpoint-IS-the-bus-client + §the-TUI-runs-locally-on-the-SSH-endpoint.

§First-explicit-observation in library: **§three-properties-of-process-separation-as-named-architectural-rationale (multi-client + isolation + remote-via-SSH-no-proxy)**.
