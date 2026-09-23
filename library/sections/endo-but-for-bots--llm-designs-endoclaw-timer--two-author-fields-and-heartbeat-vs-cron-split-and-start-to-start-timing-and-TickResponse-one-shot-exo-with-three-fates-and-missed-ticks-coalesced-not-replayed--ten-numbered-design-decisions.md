---
title: §Ten numbered Design Decisions — highest count yet
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

Ten decisions enumerated:

1. **§Tick events are messages, not iterator values** — persistence, ordering, replay.
2. **§Start-to-start timing, not end-to-start** — consistent cadence.
3. **§Resolve/reschedule, not fire-and-forget** — agent visibility + transient retry.
4. **§Immediate first tick by default** — agent's first heartbeat fires immediately.
5. **§No cron semantics** — policy is the agent's concern.
6. **§Missed ticks are coalesced, not replayed** — single message with `missedTicks` count.
7. **§Pause suppresses, not defers** — ticks during pause are lost.
8. **§Revocation is permanent** — host creates a new scheduler to restore.
9. **§One scheduler per agent, not per interval** — interval entries as files, not formulas; the scheduler is the unit of GC.
10. **§No sub-second intervals** — `minPeriodMs` floor is 1000ms.

§Five-cycles-with-numbered-Design-Decisions in library now (cycle 230 had 5 + cycle 236 had 9 + cycle 240 had 3 + cycle 242 had 7 + cycle 244 has 10). §Different-counts-each-time (3 + 5 + 7 + 9 + 10). §Cycle-244-has-the-highest-count-yet. §The-N-IS-load-bearing-not-a-template.

§Numbered-Design-Decisions-cover-non-inclusions-too: §No-cron-semantics + §No-sub-second-intervals — §two-named-non-inclusions among the ten. §The-design-affirms-what's-included-and-what's-excluded.
