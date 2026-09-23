---
title: §Missed ticks coalesced not replayed
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

§Design-Decision-6: §Missed-ticks-are-coalesced-not-replayed. *An interval that missed 4 ticks during downtime delivers **one** message with `missedTicks: 4`, not 5 separate messages.* §The-agent-decides-whether-to-compensate-or-simply-continue.

§Coalescing-IS-the-back-pressure-mechanism-on-restart — §without-it-a-long-downtime-would-cause-a-message-storm + §the-storm-might-overwhelm-the-agent's-mailbox. §When-a-buffer-of-missed-events-accumulates-during-downtime, §coalesce-them-into-one-event-with-a-named-count + §the-count-IS-the-signal-the-consumer-needs-not-the-individual-events.

§Sibling-to-cycle-242's-truncation-at-read-time-survives-Content-Length-lie — §two-different-shapes-of-named-defense-against-overwhelming-input (cycle 240 truncate-at-read-time + cycle 244 coalesce-missed-events).
