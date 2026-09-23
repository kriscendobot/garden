---
title: §Start-to-start timing not end-to-start
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

§Design-Decision-2: §Start-to-start-timing-not-end-to-start. §Each-tick-is-scheduled-at-a-fixed-offset-from-the-previous-tick's-scheduled-time + §not-from-when-it-was-resolved.

§The-named-drift-consequence: §end-to-start-timing-would-drift — *a tick that takes 5 seconds would push the cadence to 65 seconds*. §Start-to-start-keeps-the-cadence-consistent — *a 60-second interval fires 60 times per hour regardless of processing time*.

§When-the-rate-matters-more-than-the-spacing, §use-start-to-start-timing; §when-the-spacing-matters-more-than-the-rate, §use-end-to-start-timing. §The-design-makes-the-trade-off-explicit + §names-the-failure-mode-of-the-alternative.

§If-processing-takes-longer-than-one-full-period, §the-next-tick-fires-immediately-with-missedTicks-reflecting-how-many-periods-were-consumed. §Overlapping-ticks-are-prevented-by-design — §each-tick-must-resolve-or-time-out-before-the-next-fires. §The-no-overlap-invariant-IS-the-back-pressure-mechanism.
