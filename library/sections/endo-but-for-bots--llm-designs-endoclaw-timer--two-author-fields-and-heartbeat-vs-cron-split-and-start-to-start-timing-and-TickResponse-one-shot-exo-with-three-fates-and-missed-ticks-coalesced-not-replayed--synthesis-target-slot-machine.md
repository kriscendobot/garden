---
title: §Synthesis target — slot machine library
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

For a slot machine library:

- §Two-Author-fields-with-named-roles for §game-rule-doc-records-original-and-evolving-authors.
- §Status-section's-three-named-subsections for §game-feature-spec-with-Implemented-Not-yet-implemented-Deviations.
- §The-heartbeat-IS-the-core-"there" for §game-engine-tick-IS-the-game-loop's-pulse.
- §Heartbeat-vs-cron-vs-policy for §game-engine-fires-ticks-and-game-rules-decide-policy.
- §IntervalScheduler / IntervalControl two-facet for §game-tick-vs-game-tick-control.
- §TickResponse-as-one-shot-exo-with-three-fates for §game-action-response-with-resolve-reschedule-or-implicit-timeout.
- §Default-resolve-on-timeout for §game-action-default-is-forward-progress-not-retry.
- §Start-to-start timing for §game-clock-maintains-cadence-regardless-of-action-duration.
- §Missed-ticks-coalesced-not-replayed for §game-state-on-restart-doesn't-replay-skipped-frames.
- §Tick-events-as-messages-not-iterator-values for §game-events-through-existing-mail-system.
- §Exponential-backoff-with-three-named-bounds for §game-action-retry-bounded-by-three-named-clamps.
- §thisDiesIfThatDies for §game-component-tied-to-game-session-lifetime.
- §Atomic-write-via-write-then-rename for §game-state-persistence.
- §Pause-suppresses-not-defers for §game-pause-doesn't-queue-events-during-suspension.
- §Revocation-is-permanent for §game-engine-revoke-requires-new-engine-not-un-revoke.
- §No-ambient-scheduling for §game-actions-need-explicit-game-scheduler-capability.
