---
ts: 2026-05-29T01:40:24Z
kind: message
role: general-contractor
to: "*"
refs:
  - presence/endolinbot/general-contractor.md
  - contractor-slots/endolinbot/slot-1.md
  - contractor-slots/endolinbot/slot-2.md
  - contractor-slots/endolinbot/slot-3.md
---

# general-contractor re-adoption on endolinbot

Liaison session on `endolinbot` re-adopted `general-contractor` posture
at 2026-05-29T01:40:24Z per maintainer directive "You are the
contractor." The prior adoption's window through 2026-05-26 had elapsed;
the maintainer's return triggers this new adoption rather than extending
the prior one. The 2026-05-15 adoption ended with 20 PRs un-drafted and
all three slots quiesced.

## Slot files

- `contractor-slots/endolinbot/slot-1.md` (empty; will attempt design-pipeline refill first cycle)
- `contractor-slots/endolinbot/slot-2.md` (empty; deferred to slot-1 per one-initial-PR-drafting-builder cap)
- `contractor-slots/endolinbot/slot-3.md` (empty; deferred to slot-1/slot-2)

## Inheritance survey

Open garden-authored DRAFT PRs on `endojs/endo-but-for-bots` (the active
repo as of this adoption): **all four classify out-of-contractor-scope.**

| PR | State | Out-of-scope reason | Disposition |
|---|---|---|---|
| #357 | DRAFT, APPROVED, 10 CI failures | needs conductor (which the contractor does not dispatch); CI failures are pre-existing `llm`-base SECURITY.md drift per 2026-05-25 shepherd | liaison message (separately) routes to conductor or to a SECURITY.md uniformity fixer first |
| #239 | DRAFT, mirror of endojs/endo#1967 | needs boatman from kmkmbp2021 (kriskowal credentials); contractor never dispatches boatman | parked pending boatman dispatch on the credentialed host |
| #262 | DRAFT, probe of OCapN/Daemon `@transports` | probes stay DRAFT by design (gap-revealing build deliverable) | stays parked |
| #134 | DRAFT, docker self-hosting | parked per prior adoption notes | stays parked |

The first per-cycle procedure will:

1. Sync, survey, advance (no in-flight); the slot-3 refill prefer-stuck step finds no in-scope stuck PRs.
2. Attempt the design-pipeline refill for slot-1 only: walk
   `designs/` on the active repo's `llm` branch via
   `skills/design-to-pr-pipeline/SKILL.md` and
   `skills/design-queue-drift-check/SKILL.md`; if a `start-here`
   candidate emerges and no other builder holds the
   one-initial-PR-drafting-builder cap, dispatch a builder.
3. If no actionable design surfaces, slot-1 stays empty this cycle and
   the contractor writes a `message` to liaison summarizing the gap.

## Scheduling armed at adoption

- CronCreate trigger A: `<<contractor-tick>>` at prime-minute offset (target ~30 min cadence)
- CronCreate trigger B: `<<contractor-tick>>` at a second prime-minute offset (different phase)
- ScheduleWakeup at cycle close per `skills/autonomous-loop-pacing/SKILL.md`

Cron job ids will be recorded in this engagement's next `result` entry
(the cycle-close summary).

## Parent-context Monitors armed at adoption

- Inbox-drain Monitor: `while sleep 90; do bash skills/inbox-drain/inbox-drain.sh general-contractor; done`
- Slot-file change Monitor: `tail -F contractor-slots/endolinbot/slot-{1,2,3}.md`

## Stray garden-root artifacts (flag to liaison)

Untracked under `/home/kris/`:

- `contractor-slots/endolinbot/slot-1.md` plus
  `history/2026-05-22-slot1-pr316.md` — near-duplicate of the
  journal-side path. Looks like a misdirected write from a prior
  contractor cycle that targeted `/home/kris/contractor-slots/...`
  instead of `/home/kris/journal/contractor-slots/...`. Harmless; the
  authoritative state is journal-side. Suggest the liaison decide
  whether to delete or fold the small content delta back to history.
- `spackle.md` — maintainer's design draft on the spackle pattern
  (2026-05-20). Unrelated to contractor work; left in place.

Self-improvement: nothing this time.
