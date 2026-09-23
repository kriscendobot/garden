---
title: §TickResponse as one-shot exo with three fates
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

§TickResponse-IS-a-one-shot-exo: §created-fresh-per-tick + §inert-after-use-or-timeout + §two-named-active-methods (resolve + reschedule). §Three-fates-of-a-tick:

1. **§resolve()** — the tick succeeded. Scheduler advances `nextTickAt` to next period boundary.
2. **§reschedule()** — the tick failed transiently. Scheduler arms exponential-backoff retry.
3. **§Implicit-timeout-resolve** — neither method called within `tickTimeoutMs`. Scheduler logs warning + treats as implicit resolve + advances to next period.

§The-third-fate-is-the-defense-against-stuck-agents — §without-it-a-crashed-agent-would-stall-its-own-heartbeat-permanently. §Default-resolve-on-timeout (not default-reschedule); §the-default-IS-forward-progress-not-retry. §When-an-async-response-can-be-missing, §the-default-must-be-the-non-blocking-choice.

§Three-cycles-on-explicit-three-fates-of-an-operation (cycle 238 had Alt-A-rejected + Alt-B-rejected + Alt-C-deferred; cycle 240 had Alt-1-rejected + Alt-2-rejected + Alt-3-rejected; cycle 244 has resolve + reschedule + auto-timeout). §The-three-fates-pattern-recurs-across-design-shapes.

§Sibling-to-cycle-241's-postponed-handler-pattern — §two-cycles-with-deferred-response-with-explicit-resolution-callbacks. §Cycle-241's-postponed-handler-defers-every-operation-until-a-single-callback; §cycle-244's-TickResponse-defers-a-single-tick-with-two-named-resolution-callbacks-plus-an-implicit-timeout-resolution.
