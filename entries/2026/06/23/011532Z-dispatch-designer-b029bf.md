---
kind: dispatch
role: designer
host: endolinbot
posture: liaison
short_id: b029bf
dispatch_root: dispatches/designer--b029bf
repo: endojs/endo-but-for-bots
branch: design/notifier-pubsub-migration
pr_number: 507
model: opus
---

RSVP kriskowal's two reviews on PR #507 (design PR):
- Review 4549104173 (CHANGES_REQUESTED, 2026-06-23T00:34:40Z) —
  4 inline asks on the design.
- Review 4549119967 (COMMENTED, 2026-06-23T00:42:29Z) — 6 inline
  notes (mix of directives, clarifications, and affirmations).

PR #507 is a design doc at `designs/notifier-pubsub-migration.md`
authored by the steward's designer (a4a14d) — this dispatch is
the iteration on the maintainer's feedback.

Substantive direction (themes across the 10 comments):
- Layering: `@endo/stream` and `@endo/exo-stream` are different
  layers; expect `@endo/exo-pubsub` to compose with `@endo/exo-stream`.
  `@endo/pubsub` (implied, local) should gracefully lift/drop to
  the exo layer (mirror async-iterator ↔ exo-stream lifting).
- Latest-topic replay semantics: never-emitted → wait; previously
  emitted → see the latest.
- Eliminate the "usage hazard" mode at line 183 entirely.
- The `@endo/stream` mode comparison at line 218 is wrong — they
  operate at different levels; the exo-layer analog "could" exist
  but does not yet.
- Durable pubsub (line 398) is out of scope — defer.
- Back-pressure / wire-protocol guidance (line 411): backlog must
  accumulate consumer-side, not producer-side; CapTP ferries
  resolved nodes — mirror that pattern.
- Cancellation: severance not yet sensable on presence; require
  cancellation-promise argument.
- Method names at line 443 are fine; topic-Exo may distinguish
  latest vs change methods (similar to streamBase64 ↔ stream byte
  stream migration); not in scope for this iteration but design
  should leave room.

Designer's job: revise the design to incorporate all this.
Liaison drives the panel (solicitor + jurors) as the next stage
of the gamut after the designer returns.
