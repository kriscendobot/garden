---
title: §Tick events as messages not iterator values
source-slug: endo-but-for-bots--llm-designs-endoclaw-timer
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-timer.md
authors: [Kris Kowal (prompted), Joshua T Corbin (evolving)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-timer.md
total-lines: 837
ingest-cycle: 244
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed
---

§Design-Decision-1: §Tick-events-are-messages-not-iterator-values. §Three-named-benefits-of-the-message-delivery: §persistence (tick messages are persisted in the agent's mailbox and survive restarts) + §ordering (tick events interleave naturally with other messages in arrival order) + §replay (followMessages replay on restart includes tick events).

§The-existing-mail-system-is-reused-not-rebuilt — §an-AsyncIterator<Tick>-interface-would-require-a-new-delivery-mechanism + §would-not-survive-restarts-without-additional-work. §When-an-event-stream-could-use-an-existing-message-system, §reuse-the-system + §don't-build-a-parallel-delivery-mechanism + §the-reuse-IS-the-no-new-abstractions-discipline (nine-cycles-on-no-new-abstractions now: 211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244).

§Sibling-to-cycle-238's-local-idioms-cited-table — §two-different-shapes-of-explicit-reuse-of-existing-substrate (cycle 238 cites idioms + cycle 244 reuses delivery system).
