---
title: §Chat TUI section — mirrors-X-exactly discipline across the web Chat
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

Lines 164-454 carry the Chat TUI section, with subsections that each mirror a chat-* design from the cluster:

- **Concepts to adapt** (line 166) — §the-discipline-IS-adapt-not-copy.
- **Panel layout** (line 191).
- **Keybinding scheme** (line 225).
- **Modeline** (line 267).
- **Transcript rendering** (line 286).
- **Focus mode** (line 325) — mirrors `chat-focus-message`.
- **Pending commands region** (line 338) — mirrors `chat-pending-commands`.
- **Source editing** (line 358).
- **Value modal** (line 381).
- **Inventory** (line 410).
- **Spaces** (line 427).
- **Inbox vs. channel vs. forum modes** (line 440).

§First-explicit-observation in library: **§the-twelve-subsection-Chat-TUI-section-IS-a-direct-projection-from-the-twelve-chat-cluster-designs + §each-subsection-mirrors-or-adapts-a-named-web-Chat-feature**.

§The-mirror-discipline-IS-strict for `chat-focus-message` (Design Decision Dependencies row says "mirrors the web focus mode") and `chat-pending-commands` (same). For other chat-* designs the relationship is "adapted from" or "ported to terminal idiom" rather than strict mirror.

§Two-named-relationship-strengths-in-the-cluster-graph:
- §**Strict mirror** — TUI feature is state-machine-equivalent to web feature.
- §**Adapt** — TUI feature is the terminal-idiomatic version of the web feature.

§First-explicit-observation in library: **§two-named-relationship-strengths-in-the-cluster-graph (strict-mirror + adapt) — §the-Dependencies-table-encodes-relationship-strength-not-just-relationship-presence**.
