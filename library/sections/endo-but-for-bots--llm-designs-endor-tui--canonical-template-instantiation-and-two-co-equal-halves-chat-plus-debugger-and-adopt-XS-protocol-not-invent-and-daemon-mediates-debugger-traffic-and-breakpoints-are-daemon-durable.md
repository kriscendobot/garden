---
title: "endor-tui.md — canonical design-doc-template instantiation + two co-equal halves (Chat + Debugger) + adopt XS protocol not invent + daemon mediates debugger traffic + breakpoints are daemon-durable + eleven numbered Design Decisions + twelve-row Dependencies table"
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
kind: index
section_count: 19
---

Sections:

- [`endor-tui.md` — canonical design-doc-template instantiation, two co-equal halves, Rust TUI for the forward-looking Rust daemon](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-break-8d51a061--endor-tui-md-canonical-design.md)
- [§Two co-equal halves named at the top — Chat + Debugger](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--two-co-equal-halves-named-at-t.md)
- [§The three-motivation convergence pattern](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--the-three-motivation-convergen.md)
- [§Eleven numbered Design Decisions (richest cycle-ingested so far)](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--eleven-numbered-design-decisio.md)
- [§Twelve-row Dependencies table — the most-fanned-in design observed](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-break-8d51a061--twelve-row-dependencies-table.md)
- [§Six numbered Phases](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-8d51a061--six-numbered-phases.md)
- [§The XS Debugger section — adopt-but-replace discipline named at the protocol layer](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-break-8d51a061--the-xs-debugger-section-adopt.md)
- [§Chat TUI section — mirrors-X-exactly discipline across the web Chat](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--chat-tui-section-mirrors-x-exa.md)
- [§The "this document references that surface rather than duplicating it" discipline](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--the-this-document-references-t.md)
- [§"endor tui is a separate process, not embedded in the daemon" — three properties](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--endor-tui-is-a-separate-proces.md)
- [§The Known Gaps section uses `- [ ]` checklist items per the CLAUDE.md spec](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--the-known-gaps-section-uses-ch.md)
- [§The Prompt appendix — per the CLAUDE.md spec](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--the-prompt-appendix-per-the-cl.md)
- [§Cycle 269 first-explicit-observations roundup (twelve)](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--cycle-269-first-explicit-obser.md)
- [§Recurring meta-pattern counters bumped at cycle 269](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-brea-8d51a061--recurring-meta-pattern-counter.md)
- [§Synthesis target — slot machine library](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-break-8d51a061--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-da-8d51a061--tier-1-borrowing.md)
- [§Tier-2 borrowing](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-da-8d51a061--tier-2-borrowing.md)
- [§Tier-3 borrowing](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakpoints-are-da-8d51a061--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](endo-but-for-bots--llm-designs-endor-tui--canonical-template-instantiation-and-two-co-equal-halves-chat-plus-debugger-and-adopt-XS-protocol-not-invent-and-daemon-mediates-debugger-traffic-and-breakp-8d51a061--pattern-summary-tag-prefixed.md)
