---
title: §The heartbeat IS the core "there" that makes an agent tick
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

§The-load-bearing-maxim from the Problem section. §Without-a-heartbeat-capability, §agents-are-purely-reactive — §they-can-only-respond-to-messages-they-receive. §The-heartbeat-IS-the-mechanism-that-makes-an-agent-proactive.

§Three-named-uses-of-heartbeat: §drive-its-main-loop + §power-downstream-scheduling + §retry-transient-failures. §When-an-agent-needs-to-act-on-its-own-schedule, §the-heartbeat-IS-the-only-mechanism-because-SES-lockdown-removes-setTimeout-and-setInterval-from-the-global-scope.

§Capability-by-construction: §the-only-way-an-agent-can-schedule-future-execution-is-by-holding-an-IntervalScheduler-capability + §an-agent-without-the-capability-cannot-schedule-by-any-means. §No-ambient-scheduling (named in Security Considerations). §Sibling-to-cycle-234's-the-agent-never-sees-the-token + cycle-238's-the-controller-cap-the-host-retains — three-cycles-with-explicit-capability-by-construction-discipline.
