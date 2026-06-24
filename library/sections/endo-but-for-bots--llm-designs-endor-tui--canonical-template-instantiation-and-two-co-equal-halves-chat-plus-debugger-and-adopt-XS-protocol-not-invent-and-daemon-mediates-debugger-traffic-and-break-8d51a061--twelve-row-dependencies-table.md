---
title: §Twelve-row Dependencies table — the most-fanned-in design observed
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

Lines 823-838 carry a §twelve-row Dependencies table — the highest fan-in observed in any design ingested. The dependencies span:

- §**Direct sibling**: endor-bus-tui (the bus verb surface).
- §**Five chat designs**: chat-command-bar + chat-focus-message + chat-pending-commands + chat-color-schemes + chat-per-space-color-scheme + chat-spaces-home + chat-view-edit-commands (the web Chat ancestor).
- §**Worker observability**: workers-panel.
- §**Daemon substrate**: daemon-value-message + daemon-mount + daemon-agent-tools.

§First-explicit-observation in library: **§twelve-row-Dependencies-table-IS-the-highest-fan-in-observed-in-any-design — §the-fan-in-correlates-with-the-design's-position-near-the-top-of-the-dep-graph-(consuming-but-not-yet-consumed-by-others)**.

§Each-dependency-row-carries-a-named-relationship — *"TUI command bar state machine mirrors the web command bar exactly"*; *"TUI focus mode mirrors the web focus mode"*; *"Tool-call messages are first-class transcript entries"*. §the-relationship-IS-the-non-obvious-part-+-the-table-encodes-it.

§the-`mirrors-X-exactly`-relationship-IS-named (web command bar → TUI command bar) — §the-TUI-design-EXPLICITLY-promises-state-machine-equivalence-with-the-web-design; §two-named-state-machine-equivalence-relationships (chat-command-bar + chat-focus-message); §first-explicit-observation in library of §mirrors-X-exactly-as-named-state-machine-equivalence-discipline-in-a-Dependencies-table.
