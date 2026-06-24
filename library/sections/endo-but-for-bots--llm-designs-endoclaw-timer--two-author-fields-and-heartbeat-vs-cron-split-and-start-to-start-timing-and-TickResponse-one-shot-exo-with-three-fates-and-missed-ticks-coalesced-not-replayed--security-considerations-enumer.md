---
title: §Security Considerations enumerates four named attacks/defenses
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

Four-named-attack-defense-pairs:

1. **§Interval Bomb Prevention** — `maxActive` limits total; `minPeriodMs` enforces floor.
2. **§No Ambient Scheduling** — agent without scheduler cannot schedule by any means.
3. **§TickResponse Abuse** — exponential backoff bounds repeated `reschedule()` calls.
4. **§Fire-and-Forget** — `maxActive` + timeout-auto-resolve prevent resource leaks; mailbox limits provide additional bound.

§Plus-§Clock-Manipulation as a fifth-named-concern (not attack but environmental hazard). §When-a-scheduler-could-be-attacked-by-a-malicious-agent, §enumerate-each-attack-vector + §name-the-defense + §state-the-bound.

§Four-named-attack-defense-pairs-in-a-Security-Considerations-section. §When-a-design-grants-a-capability-with-resource-implications, §enumerate-the-attack-surfaces + §name-each-defense.
