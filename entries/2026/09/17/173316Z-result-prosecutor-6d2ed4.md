---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-09-17T17:33:22Z
---
Review-retrospective (prosecutor) on kriscendobot/minion.town PR #69, primary
`kriscendobot-minion.town-pr69-review-6989f40d`, review 5119120338 by kriskowal.

Verdict: **not-a-miss (new-direction)**. The maintainer's "preliminary question"
— why is the value the diff called a "reference name" (`powerReferenceName`) not a
pet name — is a naming-vocabulary refinement first surfaced in the review. The
value genuinely is an Endo `Name` (`PetName | SpecialName`); the producer adopted
the canonical vocabulary in e9478b4 (`powerReferenceName` → `powerName`). Grounds:
no seat/skill/COMMON rule encodes the Endo Name taxonomy as a check, so the panel
could not "demonstrably know" it; the adjacent naming rules address names that lie
about *type*, not non-canonical wording; no gauntlet ran nor was due (draft build
under the manual-gauntlet-trigger regime), and even a run panel carries no seat
for this vocabulary. Grounded in the world, not the primary report: primary
deliverable confirmed real (commit e9478b40 on #69, CI run 33945266616 green) —
not a false no-op.

Recorded: review-misses/dismissed/kriscendobot-minion.town-pr69-review-6989f40d.md.
No cluster minted, no threshold trip, no improvement job — the cheap dismissal
path. Adjacency logged for future calibration: first Endo *naming-vocabulary*
divergence and first on minion.town (whole naming corpus is endo-but-for-bots); if
a second recurs, revisit whether a "use Endo canonical Name vocabulary" naming
cluster is forming.

Self-improvement: nothing this time — the discriminator, store writer, and
idempotency path all behaved as documented.
