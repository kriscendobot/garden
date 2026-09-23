---
title: §IntervalScheduler / IntervalControl two-facet caretaker pattern
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

§The-canonical-caretaker-pattern: §the-agent-holds-the-scheduler-facet + §the-host-retains-the-IntervalControl-facet. §Both-are-facets-of-a-single-interval-scheduler-exo. §IntervalControl-has-host-only-methods (setMaxActive + setMinPeriodMs + pause + resume + revoke + listAll).

§Sibling-pattern-to-cycle-234's-OAuth-OAuthControl + cycle-238's-controller-client. §Three-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244). §The-pattern-is-the-design-vocabulary-for-policy-bearing-vs-policy-using-authority.

§IntervalControl-has-six-methods + §IntervalScheduler-has-three (makeInterval + list + help); §each-Interval-also-has-six-methods (label + period + setPeriod + cancel + info + help). §The-control-facet-has-more-methods-than-the-use-facet (cycle 234 sibling pattern).
