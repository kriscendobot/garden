---
title: §Heartbeat-vs-cron-vs-policy split
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

§Design-Decision-5: §No-cron-semantics. *Any higher-level scheduling policy — "run at 8 AM daily," "run every weekday," etc. — is implemented by the agent in its tick handler.* §The-interval-scheduler-knows-only-about-periods + §policy-is-the-agent's-concern.

§Three-layered-separation: §scheduler-fires-ticks-at-period-intervals + §agent-receives-ticks + §agent-decides-policy. §The-policy-IS-the-agent's-business-not-the-scheduler's. §When-a-scheduling-system-could-grow-cron-semantics, §refuse-them-and-push-policy-to-the-consumer + §the-refusal-IS-the-design-discipline.

§Sibling-to-cycle-240's-no-encoding-flag-the-daemon-does-not-negotiate-codecs and cycle-242's-no-help()-in-this-layer — §three-cycles-with-explicit-refusal-of-a-conventional-feature. §The-conventional-features-are: §encoding-negotiation (240) + §help-discoverability (242) + §cron-semantics (244). §When-the-conventional-feature-belongs-to-a-higher-layer, §the-lower-layer-MUST-refuse-it-explicitly + §name-it-as-a-numbered-Design-Decision-not-buried-in-prose.

§Sibling-pattern-to-Go's-time.Ticker-and-Tokio's-time.Interval — §cited-prior-art-by-name; §the-design-doesn't-invent-a-shape-it-points-at-the-established-shape-in-other-languages. §When-a-design-implements-a-shape-that-other-languages-already-have, §cite-the-shape-by-its-canonical-name + §the-reader-who-knows-Go-or-Rust-can-skip-to-the-distinguishing-features.
