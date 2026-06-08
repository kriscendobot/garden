---
title: "designs/endoclaw-timer.md — Two Author fields + heartbeat-vs-cron split + start-to-start timing + TickResponse one-shot exo with three fates + missed-ticks coalesced not replayed + ten Design Decisions"
source-slug: endo-but-for-bots--llm-designs-endoclaw-timer
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-timer.md
authors: [Kris Kowal (prompted), Joshua T Corbin (evolving)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-timer.md
total-lines: 837
ingest-cycle: 244
ingest-date: 2026-06-08
lane: designs
---

# EndoClaw: Core Heartbeat Scheduler — two Author fields + heartbeat-vs-cron split + start-to-start timing + TickResponse one-shot exo with three fates + missed-ticks coalesced not replayed + ten Design Decisions

A 837-line **In Progress** design (Created 2026-03-03; Updated 2026-03-18). Parent: [endoclaw](endoclaw.md). The prototype lives in `packages/genie/src/interval/` with 25 passing tests; Phase 1 only.

## §Two Author fields with named roles

```
| **Author**  | Kris Kowal (prompted)      |
| **Author**  | Joshua T Corbin (evolving) |
```

§Two-Author-field-entries with §named-roles in parens: §`(prompted)` for the original author + §`(evolving)` for the co-author who has been refining the design. §First-cycle-in-library with §two-Author-fields-with-named-roles.

§Thirty-second-honest-design-evolution-record family member; §sixteenth-different-shape in 2026-06 cluster: §two-Author-fields-with-named-roles as a §retrospective-record-of-co-authoring. §When-a-design-has-been-evolved-by-multiple-authors, §each-author-gets-their-own-Author-field-with-a-named-role + §the-named-roles-distinguish-original-from-evolutionary-contributions.

§Sibling-to-cycle-242's-Roadmap-calibration-per-git-blame (which captures evolution as time-bursts) — §cycle-244-captures-evolution-as-co-authorship. §Two-different-shapes-of-evolution-record: §temporal (cycle 242) + §personal (cycle 244).

## §The Status section's three named subsections

§Three-named-status-subsections: §Implemented (in `@endo/genie`) + §Not-yet-implemented + §Deviations-from-design. §The-§Deviations-from-design-section-is-itself-distinctive: §three-named-deviations (tick delivery via onTick callback not mail + no formula persistence + harden calls' SES context).

§When-an-implementation-deviates-from-the-design, §name-the-deviations-explicitly-in-a-Deviations-from-design-section + §don't-pretend-the-design-matches-the-implementation. §Sibling-to-cycle-238's design-revision-after-CHANGES_REQUESTED (which captures pre-implementation deviation) + cycle-242's-Roadmap-calibration-per-git-blame (which captures post-implementation history) — §cycle-244-captures-mid-implementation-deviation. §Three-different-temporal-postures-on-design-implementation-mismatch.

§Each-deviation-has-a-named-rationale: §intentional-for-prototype (callback vs mail) + §deferred-to-daemon-graduation (no formula persistence) + §context-dependent (harden in genie context). §When-a-deviation-is-deliberate, §name-it-deliberately + §name-when-the-deviation-will-be-resolved.

## §The heartbeat IS the core "there" that makes an agent tick

§The-load-bearing-maxim from the Problem section. §Without-a-heartbeat-capability, §agents-are-purely-reactive — §they-can-only-respond-to-messages-they-receive. §The-heartbeat-IS-the-mechanism-that-makes-an-agent-proactive.

§Three-named-uses-of-heartbeat: §drive-its-main-loop + §power-downstream-scheduling + §retry-transient-failures. §When-an-agent-needs-to-act-on-its-own-schedule, §the-heartbeat-IS-the-only-mechanism-because-SES-lockdown-removes-setTimeout-and-setInterval-from-the-global-scope.

§Capability-by-construction: §the-only-way-an-agent-can-schedule-future-execution-is-by-holding-an-IntervalScheduler-capability + §an-agent-without-the-capability-cannot-schedule-by-any-means. §No-ambient-scheduling (named in Security Considerations). §Sibling-to-cycle-234's-the-agent-never-sees-the-token + cycle-238's-the-controller-cap-the-host-retains — three-cycles-with-explicit-capability-by-construction-discipline.

## §Heartbeat-vs-cron-vs-policy split

§Design-Decision-5: §No-cron-semantics. *Any higher-level scheduling policy — "run at 8 AM daily," "run every weekday," etc. — is implemented by the agent in its tick handler.* §The-interval-scheduler-knows-only-about-periods + §policy-is-the-agent's-concern.

§Three-layered-separation: §scheduler-fires-ticks-at-period-intervals + §agent-receives-ticks + §agent-decides-policy. §The-policy-IS-the-agent's-business-not-the-scheduler's. §When-a-scheduling-system-could-grow-cron-semantics, §refuse-them-and-push-policy-to-the-consumer + §the-refusal-IS-the-design-discipline.

§Sibling-to-cycle-240's-no-encoding-flag-the-daemon-does-not-negotiate-codecs and cycle-242's-no-help()-in-this-layer — §three-cycles-with-explicit-refusal-of-a-conventional-feature. §The-conventional-features-are: §encoding-negotiation (240) + §help-discoverability (242) + §cron-semantics (244). §When-the-conventional-feature-belongs-to-a-higher-layer, §the-lower-layer-MUST-refuse-it-explicitly + §name-it-as-a-numbered-Design-Decision-not-buried-in-prose.

§Sibling-pattern-to-Go's-time.Ticker-and-Tokio's-time.Interval — §cited-prior-art-by-name; §the-design-doesn't-invent-a-shape-it-points-at-the-established-shape-in-other-languages. §When-a-design-implements-a-shape-that-other-languages-already-have, §cite-the-shape-by-its-canonical-name + §the-reader-who-knows-Go-or-Rust-can-skip-to-the-distinguishing-features.

## §IntervalScheduler / IntervalControl two-facet caretaker pattern

§The-canonical-caretaker-pattern: §the-agent-holds-the-scheduler-facet + §the-host-retains-the-IntervalControl-facet. §Both-are-facets-of-a-single-interval-scheduler-exo. §IntervalControl-has-host-only-methods (setMaxActive + setMinPeriodMs + pause + resume + revoke + listAll).

§Sibling-pattern-to-cycle-234's-OAuth-OAuthControl + cycle-238's-controller-client. §Three-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244). §The-pattern-is-the-design-vocabulary-for-policy-bearing-vs-policy-using-authority.

§IntervalControl-has-six-methods + §IntervalScheduler-has-three (makeInterval + list + help); §each-Interval-also-has-six-methods (label + period + setPeriod + cancel + info + help). §The-control-facet-has-more-methods-than-the-use-facet (cycle 234 sibling pattern).

## §TickResponse as one-shot exo with three fates

§TickResponse-IS-a-one-shot-exo: §created-fresh-per-tick + §inert-after-use-or-timeout + §two-named-active-methods (resolve + reschedule). §Three-fates-of-a-tick:

1. **§resolve()** — the tick succeeded. Scheduler advances `nextTickAt` to next period boundary.
2. **§reschedule()** — the tick failed transiently. Scheduler arms exponential-backoff retry.
3. **§Implicit-timeout-resolve** — neither method called within `tickTimeoutMs`. Scheduler logs warning + treats as implicit resolve + advances to next period.

§The-third-fate-is-the-defense-against-stuck-agents — §without-it-a-crashed-agent-would-stall-its-own-heartbeat-permanently. §Default-resolve-on-timeout (not default-reschedule); §the-default-IS-forward-progress-not-retry. §When-an-async-response-can-be-missing, §the-default-must-be-the-non-blocking-choice.

§Three-cycles-on-explicit-three-fates-of-an-operation (cycle 238 had Alt-A-rejected + Alt-B-rejected + Alt-C-deferred; cycle 240 had Alt-1-rejected + Alt-2-rejected + Alt-3-rejected; cycle 244 has resolve + reschedule + auto-timeout). §The-three-fates-pattern-recurs-across-design-shapes.

§Sibling-to-cycle-241's-postponed-handler-pattern — §two-cycles-with-deferred-response-with-explicit-resolution-callbacks. §Cycle-241's-postponed-handler-defers-every-operation-until-a-single-callback; §cycle-244's-TickResponse-defers-a-single-tick-with-two-named-resolution-callbacks-plus-an-implicit-timeout-resolution.

## §Start-to-start timing not end-to-start

§Design-Decision-2: §Start-to-start-timing-not-end-to-start. §Each-tick-is-scheduled-at-a-fixed-offset-from-the-previous-tick's-scheduled-time + §not-from-when-it-was-resolved.

§The-named-drift-consequence: §end-to-start-timing-would-drift — *a tick that takes 5 seconds would push the cadence to 65 seconds*. §Start-to-start-keeps-the-cadence-consistent — *a 60-second interval fires 60 times per hour regardless of processing time*.

§When-the-rate-matters-more-than-the-spacing, §use-start-to-start-timing; §when-the-spacing-matters-more-than-the-rate, §use-end-to-start-timing. §The-design-makes-the-trade-off-explicit + §names-the-failure-mode-of-the-alternative.

§If-processing-takes-longer-than-one-full-period, §the-next-tick-fires-immediately-with-missedTicks-reflecting-how-many-periods-were-consumed. §Overlapping-ticks-are-prevented-by-design — §each-tick-must-resolve-or-time-out-before-the-next-fires. §The-no-overlap-invariant-IS-the-back-pressure-mechanism.

## §Missed ticks coalesced not replayed

§Design-Decision-6: §Missed-ticks-are-coalesced-not-replayed. *An interval that missed 4 ticks during downtime delivers **one** message with `missedTicks: 4`, not 5 separate messages.* §The-agent-decides-whether-to-compensate-or-simply-continue.

§Coalescing-IS-the-back-pressure-mechanism-on-restart — §without-it-a-long-downtime-would-cause-a-message-storm + §the-storm-might-overwhelm-the-agent's-mailbox. §When-a-buffer-of-missed-events-accumulates-during-downtime, §coalesce-them-into-one-event-with-a-named-count + §the-count-IS-the-signal-the-consumer-needs-not-the-individual-events.

§Sibling-to-cycle-242's-truncation-at-read-time-survives-Content-Length-lie — §two-different-shapes-of-named-defense-against-overwhelming-input (cycle 240 truncate-at-read-time + cycle 244 coalesce-missed-events).

## §Tick events as messages not iterator values

§Design-Decision-1: §Tick-events-are-messages-not-iterator-values. §Three-named-benefits-of-the-message-delivery: §persistence (tick messages are persisted in the agent's mailbox and survive restarts) + §ordering (tick events interleave naturally with other messages in arrival order) + §replay (followMessages replay on restart includes tick events).

§The-existing-mail-system-is-reused-not-rebuilt — §an-AsyncIterator<Tick>-interface-would-require-a-new-delivery-mechanism + §would-not-survive-restarts-without-additional-work. §When-an-event-stream-could-use-an-existing-message-system, §reuse-the-system + §don't-build-a-parallel-delivery-mechanism + §the-reuse-IS-the-no-new-abstractions-discipline (nine-cycles-on-no-new-abstractions now: 211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244).

§Sibling-to-cycle-238's-local-idioms-cited-table — §two-different-shapes-of-explicit-reuse-of-existing-substrate (cycle 238 cites idioms + cycle 244 reuses delivery system).

## §Exponential backoff with named formula

```
baseBackoff = min(1000, periodMs / 10)
backoffDelay = min(baseBackoff * 2^(rescheduleCount - 1), tickTimeoutMs)
retryAt = min(now + backoffDelay, scheduledAt + tickTimeoutMs)
```

§The-formula-is-named-with-three-line-structure: §base-backoff (proportional to period but capped at 1 second) + §exponential-doubling-per-reschedule (capped at tick timeout) + §retry-time-floor-at-scheduled-deadline (so backoff can't exceed the tick's own deadline). §Three-named-bounds-on-the-backoff.

§Backoff-caps-at-tick-deadline — §if-the-backoff-delay-would-push-the-retry-past-the-tick-deadline, §the-scheduler-auto-resolves-and-advances-to-the-next-period-instead. §The-cap-IS-the-anti-livelock-mechanism.

§Sibling-to-cycle-237's-three-tiers-of-tie-breaking — §two-different-shapes-of-three-named-bounds. §Cycle-237's-three-bounds-are-the-tie-breakers-for-comparison; §cycle-244's-three-bounds-are-the-clamps-on-retry-timing.

## §thisDiesIfThatDies + onCancel for lifetime

```js
context.onCancel(() => {
  // Disarm all active timeouts and deadlines
  for (const [, handle] of activeTimeouts) clearTimeout(handle);
  // ...
});

context.thisDiesIfThatDies(agentId);
```

§Two-named-lifetime-mechanisms: §context.onCancel-for-cleanup-on-cancellation + §context.thisDiesIfThatDies-for-lifetime-linkage. §When-the-scheduler-is-cancelled, §clean-up-timeouts; §when-the-agent-is-cancelled, §the-scheduler-is-cancelled-too.

§Two-cycles-with-thisDiesIfThatDies-named-lifetime-linkage (cycles 236 daemon-make-archive + 244 endoclaw-timer). §Cycle-236-used-thisDiesIfThatDies-for-scratch-state-tied-to-session; §cycle-244-uses-it-for-scheduler-tied-to-agent. §Two-different-substrates-but-the-same-named-mechanism.

§Sibling-to-cycle-242's-no-help()-in-this-layer — §two-cycles-with-explicit-layered-cleanup-by-cancellation-context.

## §Persistence with atomic write-then-rename

§Atomic-write-via-write-then-rename established in `synced-pet-store`:

```
async function atomicWriteJSON(filePowers, targetDir, fileName, value):
    temporaryPath = filePowers.joinPath(targetDir, `.tmp.${randomHex()}`)
    finalPath = filePowers.joinPath(targetDir, fileName)
    await filePowers.writeFileText(temporaryPath, JSON.stringify(value) + '\n')
    await filePowers.renamePath(temporaryPath, finalPath)
```

§Atomic-rename-after-write as named persistence pattern. §The-temporary-path-uses-`.tmp.`-prefix-plus-random-hex + §the-final-path-is-the-canonical-name + §the-rename-is-atomic-on-POSIX. §When-a-persisted-entry-must-be-readable-or-completely-absent-not-partially-written, §write-to-a-temporary-path-and-rename-atomically. §Sibling-to-cycle-166's-daemon-mount POSIX-rename-atomicity discipline.

§In-memory-`Map<string, NodeJS.Timeout>`-NOT-persisted-rebuilt-on-startup — §the-in-memory-state-is-derived-from-the-persisted-state + §the-persisted-state-is-the-source-of-truth + §the-in-memory-state-is-the-cache. §When-restart-is-a-real-scenario, §design-the-in-memory-state-as-derived-from-the-persisted-state-not-the-other-way-around.

## §Pause suppresses not defers

§Design-Decision-7: §Pause-suppresses-not-defers. *Ticks that would have occurred during a pause are **lost**, not queued. This matches the intent of pause and avoids a burst of suppressed events on resume.*

§Suppression-vs-deferral-as-named-distinction. §When-a-control-mechanism-stops-something-temporarily, §choose-explicitly-between-suppress-and-defer + §name-the-choice + §state-the-reason. §The-host-can-inspect-listAll-to-audit-what-was-suppressed.

§Sibling-pattern-to-cycle-235's-explicit-termination-signal-via-undefined — §two-cycles-with-explicit-non-action-signaled-explicitly. §Cycle-235's-extractMin-signals-no-more-work-via-undefined; §cycle-244's-pause-signals-suppression-not-deferral.

## §Revocation is permanent

§Design-Decision-8: §Revocation-is-permanent. *Once `revoke()` is called, the `IntervalScheduler` capability is dead. The host must create a new scheduler to restore access.*

§Permanence-as-named-discipline + §the-restoration-mechanism-IS-creating-a-new-scheduler-not-un-revoking. §When-revocation-is-permanent, §state-the-permanence-explicitly + §name-the-restoration-mechanism.

§Sibling-pattern-to-cycle-234's-two-layered-revocation — §cycle-234's-revocation-is-local-authoritative-plus-remote-best-effort; §cycle-244's-revocation-is-local-only-permanent. §Two-different-shapes-of-revocation.

## §Security Considerations enumerates four named attacks/defenses

Four-named-attack-defense-pairs:

1. **§Interval Bomb Prevention** — `maxActive` limits total; `minPeriodMs` enforces floor.
2. **§No Ambient Scheduling** — agent without scheduler cannot schedule by any means.
3. **§TickResponse Abuse** — exponential backoff bounds repeated `reschedule()` calls.
4. **§Fire-and-Forget** — `maxActive` + timeout-auto-resolve prevent resource leaks; mailbox limits provide additional bound.

§Plus-§Clock-Manipulation as a fifth-named-concern (not attack but environmental hazard). §When-a-scheduler-could-be-attacked-by-a-malicious-agent, §enumerate-each-attack-vector + §name-the-defense + §state-the-bound.

§Four-named-attack-defense-pairs-in-a-Security-Considerations-section. §When-a-design-grants-a-capability-with-resource-implications, §enumerate-the-attack-surfaces + §name-each-defense.

## §Ten numbered Design Decisions — highest count yet

Ten decisions enumerated:

1. **§Tick events are messages, not iterator values** — persistence, ordering, replay.
2. **§Start-to-start timing, not end-to-start** — consistent cadence.
3. **§Resolve/reschedule, not fire-and-forget** — agent visibility + transient retry.
4. **§Immediate first tick by default** — agent's first heartbeat fires immediately.
5. **§No cron semantics** — policy is the agent's concern.
6. **§Missed ticks are coalesced, not replayed** — single message with `missedTicks` count.
7. **§Pause suppresses, not defers** — ticks during pause are lost.
8. **§Revocation is permanent** — host creates a new scheduler to restore.
9. **§One scheduler per agent, not per interval** — interval entries as files, not formulas; the scheduler is the unit of GC.
10. **§No sub-second intervals** — `minPeriodMs` floor is 1000ms.

§Five-cycles-with-numbered-Design-Decisions in library now (cycle 230 had 5 + cycle 236 had 9 + cycle 240 had 3 + cycle 242 had 7 + cycle 244 has 10). §Different-counts-each-time (3 + 5 + 7 + 9 + 10). §Cycle-244-has-the-highest-count-yet. §The-N-IS-load-bearing-not-a-template.

§Numbered-Design-Decisions-cover-non-inclusions-too: §No-cron-semantics + §No-sub-second-intervals — §two-named-non-inclusions among the ten. §The-design-affirms-what's-included-and-what's-excluded.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Two-Author-fields-with-named-roles (`(prompted)` + `(evolving)`) as retrospective co-authoring record.
- §Status-section's-three-named-subsections (Implemented + Not-yet-implemented + Deviations-from-design).
- §The-heartbeat-IS-the-core-"there"-that-makes-an-agent-tick — load-bearing maxim.
- §Heartbeat-vs-cron-vs-policy three-layered-separation.
- §IntervalScheduler / IntervalControl two-facet caretaker pattern (third instance: 234 + 238 + 244).
- §TickResponse-as-one-shot-exo-with-three-fates (resolve + reschedule + implicit-timeout-resolve).
- §Default-resolve-on-timeout — the default IS forward progress not retry.
- §Start-to-start timing not end-to-start — named drift consequence.
- §Missed-ticks-coalesced-not-replayed.
- §Tick-events-as-messages-not-iterator-values — three named benefits (persistence + ordering + replay).
- §Exponential-backoff-with-three-named-bounds (base proportional to period + doubling per reschedule + retry-time floor at deadline).
- §thisDiesIfThatDies + onCancel — two named lifetime mechanisms.
- §Atomic-write-via-write-then-rename — POSIX rename atomicity.
- §In-memory-state-is-derived-from-the-persisted-state — restart-aware design.
- §Pause-suppresses-not-defers — explicit named distinction.
- §Revocation-is-permanent — named discipline.

**Tier-2 (design discipline):**

- §No-ambient-scheduling — capability-by-construction.
- §Cited-prior-art-by-name (Go's `time.Ticker` + Tokio's `time::Interval`).
- §Three-cycles-with-explicit-refusal-of-conventional-feature (240 + 242 + 244).
- §Four-named-attack-defense-pairs-in-Security-Considerations.
- §Ten-numbered-Design-Decisions — highest count yet.
- §Two-named-non-inclusions among the Design Decisions.

**Tier-3 (named comparisons):**

- §Three-different-temporal-postures-on-design-implementation-mismatch (238 pre + 244 mid + 242 post).
- §Two-different-shapes-of-evolution-record (242 temporal + 244 personal).

## §Synthesis target — slot machine library

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

## §Library meta-counters

- §Library-reaches-750-sections at cycle 244 (designs-lane endoclaw-timer).
- §Seventy-eighth-consecutive designs-chat alternation cycle (cycles 166-244).
- §Thirty-second-honest-design-evolution-record family member (new shape: §two-Author-fields-with-named-roles as retrospective co-authoring record + §Status-section's-three-named-subsections including Deviations-from-design).
- §Sixteenth-different-shape-of-design-evolution-record in 2026-06 cluster (214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228 + 230 + 232 + 236 + 238 + 240 + 242 + 244).
- §Nine-cycles-on-no-new-abstractions discipline (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244) — the design reuses the mail system rather than building a new delivery mechanism.
- §Seven-cycles-with-Dependencies-table-with-Relationship-column (224 + 230 + 236 + 238 + 240 + 242 + 244).
- §Five-cycles-with-numbered-Design-Decisions (230 had 5 + 236 had 9 + 240 had 3 + 242 had 7 + 244 has 10) — different counts each time; §the-N-IS-load-bearing-not-a-template.
- §Three-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244).
- §Three-cycles-with-explicit-refusal-of-conventional-feature (240 no-encoding + 242 no-help + 244 no-cron).
- §Three-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244).
- §Three-different-temporal-postures-on-design-implementation-mismatch (238 pre + 244 mid + 242 post).
- §Two-cycles-with-thisDiesIfThatDies-named-lifetime-linkage (236 + 244).
- §Two-different-shapes-of-evolution-record (242 temporal + 244 personal).
- §Three-cycles-on-explicit-three-fates-of-an-operation (238 alts + 240 alts + 244 tick fates).
- §First-cycle-with-two-Author-fields-with-named-roles in library.
- §First-cycle-with-Deviations-from-design-as-named-Status-subsection.
- §First-cycle-with-cited-prior-art-by-name across languages (Go + Rust).
- §First-cycle-with-four-named-attack-defense-pairs-in-Security-Considerations.

(Kris Kowal (prompted) + Joshua T Corbin (evolving) authored)
