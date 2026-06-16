---
title: §Eleven numbered Design Decisions (richest cycle-ingested so far)
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

Lines 756-822 carry **eleven** numbered Design Decisions, each with named rationale:

1. **`ratatui` + `crossterm` over `cursive`** — §immediate-mode-rendering-over-retained-widget-trees-for-streaming-data; §the-`cursive`-rejection-IS-named (would force synchronizing widget state with async daemon state, creating a second source of truth).
2. **Alternate-screen, full redraw on events rather than line log** — §random-access-vs-line-scrolling.
3. **Modal input** — §the-mode-set-IS-small (normal + insert + focus + modal); §the-modes-mirror-the-web-Chat's-implicit-states-rather-than-inventing-new-ones.
4. **Adopt XS's native debugger protocol rather than inventing one** — §the-`mxDebug`-protocol-IS-the-canonical-name; §`xsbug`-IS-existence-proof-that-the-protocol-IS-sufficient-for-production-debugging.
5. **Daemon mediates debugger traffic; TUI speaks only bus verbs** — §three-named-properties-of-the-daemon-mediation (multi-client + multi-TUI + reconnectable); §capability-based-access-control (a guest cannot attach to another guest's worker).
6. **Breakpoints are daemon-durable** — §when-a-developer's-mental-model-IS-"I-set-a-breakpoint-here", §the-breakpoint-must-survive-TUI-restarts + §the-agent-can-block-on-the-breakpoint-with-no-TUI-attached.
7. **Debugger opt-in per worker** — §workers-launched-without-the-debug-flag-show-a-greyed-out-state; §this-prevents-surprise-pauses-in-production-deployments.
8. **`endor tui` is a separate process, not embedded in the daemon** — §three-named-properties-of-the-process-separation (multiple TUIs + TUI crash cannot take down daemon + remote SSH operation works without proxying).
9. **No `xsbug` compatibility mode** — §named-non-goal; §the-protocol-IS-consumed + §the-tool-IS-not-committed-to-being-a-drop-in-replacement.
10. **Chat and debugger share one bus connection** — §the-two-views-multiplex-over-one-socket; §reconnect-logic-is-shared.
11. **Mouse capture off by default** — §native-terminal-selection-IS-a-workflow-developers-care-about + §mouse-IS-a-toggle.

§First-explicit-observation in library: **§eleven-numbered-Design-Decisions-IS-the-richest-Design-Decisions-section-cycle-ingested-so-far — §the-section-IS-the-cumulative-rationale-record-for-the-design-and-the-arity-correlates-with-the-design's-complexity**.

§Several-decisions-IS-of-the-shape-"X over Y, because Z" — §three-named-such-decisions-in-this-list (1 + 4 + 10); §the-`X-over-Y-because-Z`-rationale-shape-IS-the-canonical-form-for-comparative-decisions.

§Several-decisions-IS-of-the-shape-"X because Y" — §eight-named-such-decisions; §the-`X-because-Y`-rationale-shape-IS-the-canonical-form-for-positive-decisions.

§First-explicit-observation in library: **§two-named-Design-Decision-rationale-shapes (`X-over-Y-because-Z` for comparative + `X-because-Y` for positive)**.
