---
title: §Borrowable patterns
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
