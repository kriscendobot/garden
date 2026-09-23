---
title: §Exponential backoff with named formula
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

```
baseBackoff = min(1000, periodMs / 10)
backoffDelay = min(baseBackoff * 2^(rescheduleCount - 1), tickTimeoutMs)
retryAt = min(now + backoffDelay, scheduledAt + tickTimeoutMs)
```

§The-formula-is-named-with-three-line-structure: §base-backoff (proportional to period but capped at 1 second) + §exponential-doubling-per-reschedule (capped at tick timeout) + §retry-time-floor-at-scheduled-deadline (so backoff can't exceed the tick's own deadline). §Three-named-bounds-on-the-backoff.

§Backoff-caps-at-tick-deadline — §if-the-backoff-delay-would-push-the-retry-past-the-tick-deadline, §the-scheduler-auto-resolves-and-advances-to-the-next-period-instead. §The-cap-IS-the-anti-livelock-mechanism.

§Sibling-to-cycle-237's-three-tiers-of-tie-breaking — §two-different-shapes-of-three-named-bounds. §Cycle-237's-three-bounds-are-the-tie-breakers-for-comparison; §cycle-244's-three-bounds-are-the-clamps-on-retry-timing.
