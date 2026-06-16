---
title: §`E(timer).schedule(cron, callback)` — note vs cycle 244's interface
source-slug: endo-but-for-bots--llm-designs-endoclaw-proactive-messages
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-proactive-messages.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-proactive-messages.md
total-lines: 74
ingest-cycle: 257
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design
---

§The-code-example-uses-`E(timer).schedule('0 8 * * *', callback)` — §cron-string-as-the-scheduler-API. §This-conflicts-with-cycle-244's-IntervalScheduler-which-takes-periodMs-not-cron. §Two-cycles-with-internally-inconsistent-design-vocabulary-in-the-same-cluster (244 + 257).

§Three-named-possibilities for the conflict: §the-Proactive-Messages-design-predates-the-Heartbeat-Scheduler-design-and-was-not-updated + §the-`timer`-in-cycle-257-is-a-different-capability-than-cycle-244's-IntervalScheduler + §the-cron-string-IS-meant-as-illustrative-pseudocode-not-the-literal-API.

§Reading-the-cycle-244-design-carefully (No-cron-semantics — Design Decision 5): *Any higher-level scheduling policy — "run at 8 AM daily," "run every weekday," etc. — is implemented by the agent in its tick handler*. §So-cycle-244's-IntervalScheduler-doesn't-support-cron + §cycle-257's-`E(timer).schedule('0 8 * * *', callback)`-must-be-an-agent-side-pseudocode-wrapper-around-the-IntervalScheduler.

§First-explicit-observation in library of §two-cluster-members-with-internally-inconsistent-design-vocabulary-resolved-by-reading-as-pseudocode. §The-inconsistency-IS-a-signal-that-the-cluster-vocabulary-is-still-evolving + §later-designs-may-clarify-which-shape-is-canonical.

§Sibling-pattern-to-cycle-250's-Options-Considered-with-preferred — §two-cycles-where-the-design-text-implies-a-canonical-API-that-was-revised-later. §Two-cycles-with-evidence-of-cluster-vocabulary-evolution (250 + 257).
