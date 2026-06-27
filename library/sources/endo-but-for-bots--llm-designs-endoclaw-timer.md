---
title: "endoclaw-timer — Core heartbeat scheduler with start-to-start timing and TickResponse one-shot exo"
source-slug: endo-but-for-bots--llm-designs-endoclaw-timer
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-timer.md
authors: [Kris Kowal (prompted), Joshua T Corbin (evolving)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-timer.md
total-lines: 837
status: In Progress (2026-03-03 → 2026-03-18; Phase 1 prototype in @endo/genie)
ingest-cycle: 244
ingest-date: 2026-06-08
lane: designs
---

# endoclaw-timer.md

A 837-line **In Progress** design for `IntervalScheduler` / `IntervalControl` — the heartbeat capability that lets an SES-locked agent schedule future execution. Parent: endoclaw. Phase 1 prototype lives in `packages/genie/src/interval/`.

## Key design moves

- **§Two Author fields with named roles** — `(prompted)` original + `(evolving)` co-author; first cycle in library.
- **§Status section's three named subsections** — Implemented + Not-yet-implemented + Deviations-from-design; the Deviations subsection itself distinctive.
- **§The heartbeat IS the core "there" that makes an agent tick** — load-bearing maxim.
- **§Heartbeat-vs-cron-vs-policy three-layered separation** — scheduler fires ticks, agent decides policy.
- **§IntervalScheduler / IntervalControl two-facet caretaker pattern** (third instance: 234 + 238 + 244).
- **§TickResponse as one-shot exo with three fates** — resolve + reschedule + implicit-timeout-resolve; default is forward progress not retry.
- **§Start-to-start timing not end-to-start** — named drift consequence.
- **§Missed ticks coalesced not replayed** — single message with `missedTicks` count.
- **§Tick events as messages not iterator values** — three named benefits (persistence + ordering + replay).
- **§Exponential backoff with three named bounds** (base proportional to period + doubling per reschedule + retry-time floor at deadline).
- **§thisDiesIfThatDies + onCancel** for lifetime — two named mechanisms.
- **§Atomic write via write-then-rename** — POSIX rename atomicity for entry persistence.
- **§Pause suppresses not defers** — named distinction.
- **§Revocation is permanent** — host creates new scheduler to restore.
- **§Cited prior art by name** — Go's `time.Ticker` + Tokio's `time::Interval`.
- **§No-ambient-scheduling** — capability by construction.
- **§Four named attack-defense pairs** in Security Considerations.
- **§Ten numbered Design Decisions** — highest count yet in library.

## Section files

- [§two-Author-fields + §heartbeat-vs-cron-split + §start-to-start-timing + §TickResponse-one-shot-exo-with-three-fates + §missed-ticks-coalesced-not-replayed](../sections/endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed.md) — full 837-line design ingest.

## Ingest scope

Cycle 244 (designs-lane): full 837-line ingest. §First-explicit-observation of four patterns: §two-Author-fields-with-named-roles + §Deviations-from-design as named Status subsection + §cited-prior-art-by-name across languages + §four-named-attack-defense-pairs in Security Considerations.
