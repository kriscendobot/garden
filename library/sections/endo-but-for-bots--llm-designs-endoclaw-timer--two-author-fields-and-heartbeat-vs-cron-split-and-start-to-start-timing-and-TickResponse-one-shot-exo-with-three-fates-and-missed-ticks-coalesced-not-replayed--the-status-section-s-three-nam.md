---
title: §The Status section's three named subsections
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

§Three-named-status-subsections: §Implemented (in `@endo/genie`) + §Not-yet-implemented + §Deviations-from-design. §The-§Deviations-from-design-section-is-itself-distinctive: §three-named-deviations (tick delivery via onTick callback not mail + no formula persistence + harden calls' SES context).

§When-an-implementation-deviates-from-the-design, §name-the-deviations-explicitly-in-a-Deviations-from-design-section + §don't-pretend-the-design-matches-the-implementation. §Sibling-to-cycle-238's design-revision-after-CHANGES_REQUESTED (which captures pre-implementation deviation) + cycle-242's-Roadmap-calibration-per-git-blame (which captures post-implementation history) — §cycle-244-captures-mid-implementation-deviation. §Three-different-temporal-postures-on-design-implementation-mismatch.

§Each-deviation-has-a-named-rationale: §intentional-for-prototype (callback vs mail) + §deferred-to-daemon-graduation (no formula persistence) + §context-dependent (harden in genie context). §When-a-deviation-is-deliberate, §name-it-deliberately + §name-when-the-deviation-will-be-resolved.
