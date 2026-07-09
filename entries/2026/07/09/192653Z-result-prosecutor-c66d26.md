---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-09T19:26:54Z
---
---
kind: result
role: prosecutor
project: endojs-endo-but-for-bots
refs:
  - review-misses/dismissed/endojs-endo-but-for-bots-pr89-review-8f676f32.md
---

# Review retrospective: endojs/endo-but-for-bots PR #89 (review 4658732729) — DISMISSED (new-direction)

Second-loop retrospective on the maintainer's APPROVED review of the
`docs(designs): propose genie-integration` PR. Verdict: **not-a-miss**, category
**new-direction**. No cluster minted; no improvement job dispatched.

**Grounds (short):** #89 is a design-proposal PR that ships one new design doc
(`designs/genie-integration.md`); design PRs run no garden code panel, so the
maintainer's review IS the review surface. All 8 inline notes are the maintainer's
own architectural direction and forward intent (prefer `EndoDirectory`/`@endo/exo-*`
primitives, embrace Pi now + schedule a release-watch, sink the debug depth-prefix
into daemon metadata, eventual intent to retire genie/lal/fae). These are shaping
direction first stated in an approval — nobody could anticipate them, and no
standing rule existed and failed to bind (so the severity-bypass precondition is
absent). Structurally identical to the recorded #611 design-PR dismissal.

**Primary loop (unchanged):** the primary `...-review-8f676f32` job already
integrated every note into the doc, created the `pi-release-watch` weekly schedule,
and handed the merge to a conductor.

Recorded via `review-miss-record.sh record`; the dismissal is CAS-pushed to
journal2 so this comment is never re-litigated.

Self-improvement: no friction on this job; the discriminator, store writer, and
idempotency pre-check all behaved as documented, and the #611 precedent made the
design-PR-is-its-own-review-surface call fast.
