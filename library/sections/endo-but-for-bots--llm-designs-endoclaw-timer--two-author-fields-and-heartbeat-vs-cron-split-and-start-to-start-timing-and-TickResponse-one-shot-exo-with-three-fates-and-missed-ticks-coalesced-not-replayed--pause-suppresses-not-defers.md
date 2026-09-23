---
title: §Pause suppresses not defers
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

§Design-Decision-7: §Pause-suppresses-not-defers. *Ticks that would have occurred during a pause are **lost**, not queued. This matches the intent of pause and avoids a burst of suppressed events on resume.*

§Suppression-vs-deferral-as-named-distinction. §When-a-control-mechanism-stops-something-temporarily, §choose-explicitly-between-suppress-and-defer + §name-the-choice + §state-the-reason. §The-host-can-inspect-listAll-to-audit-what-was-suppressed.

§Sibling-pattern-to-cycle-235's-explicit-termination-signal-via-undefined — §two-cycles-with-explicit-non-action-signaled-explicitly. §Cycle-235's-extractMin-signals-no-more-work-via-undefined; §cycle-244's-pause-signals-suppression-not-deferral.
