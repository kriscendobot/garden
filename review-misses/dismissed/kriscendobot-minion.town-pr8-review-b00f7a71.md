---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr8-review-b00f7a71
verdict: not-a-miss
category: new-direction
pr: 8
repo: kriscendobot/minion.town
comment_url: https://github.com/kriscendobot/minion.town/pull/8#pullrequestreview-4719616508
identity: kriscendobot/minion.town#8:review:4719616508:retro
producing_role: designer
severity: minor
grounds: >
  kriskowal (the repo owner and maintainer) submitted review 4719616508 on PR #8
  with state APPROVED and an EMPTY review body, carrying seven inline comments on
  designs/ertp-credits.md. PR #8 is a maintainer-directed DESIGN PR (spec only, no
  live change): a single-file addition of the ERTP-credits design doc, which by
  construction closes with an explicit "Open questions for the maintainer" section
  (sub-brands vs payee-locking, bearer-final vs escrow-shaped draws, the Endo
  package's name and home, expiry's clock, reflect/redeem fees, refund interplay,
  reserve custody). This retro judges whether the garden REVIEW PROCESS should have
  anticipated these seven comments and concludes it could not have, for a
  dispositive structural reason: every one of the seven is a maintainer DECISION on
  a question the design deliberately deferred to the maintainer, not a critique of a
  defect. Re-fetched read-only in this retro: the seven comments are answers —
  "Builder's discretion." / "No." / "Start in gateway. Do not export. This should be
  a thin layer on ERTP..." / "We can temporarily rely on our own, unconfined timer
  service..." / "Yes. Both a fee and a rate limit." / "Allow negative." / "Let's
  revisit storage in general as minion.town provides AWS specific alternatives...".
  These resolve the doc's open questions (where the Endo package lives, the expiry
  clock, whether to charge fees/rate-limits, negative refund balances, storage
  strategy). There is no bug, style violation, missed edge case, spec breach, or
  standing convention that "failed to bind"; there is nothing a panel seat, gate, or
  standing instruction could have caught ahead of the maintainer, because the input
  is taste-and-scope adjudication of a proposal, not feedback on a work product. A
  design PR's whole purpose is to elicit exactly these decisions; the review is the
  design loop working as intended, and the APPROVED state confirms the maintainer
  accepted the proposal while steering its open points. Same class as the pr3/pr4/
  pr6 minion.town retros and the endo #123/#604/#631 dismissals: a maintainer
  ANSWERING surfaced questions / steering direction, not a garden review-process
  miss. The PR's own history confirms the garden handled it correctly — the primary
  job (pr8-review-b00f7a71) resolved all seven inline decisions in ff2aec7, replied
  to every thread, verified tests/typecheck green, and posted the conductor job for
  merge. Recorded as a durable dismissal so the same review is never re-litigated.
  No cluster minted; no improvement dispatched.
---

# Dismissal: minion.town #8 review 4719616508 (retro)

kriskowal (the repo owner) APPROVED PR #8 — a maintainer-directed, spec-only
DESIGN PR adding designs/ertp-credits.md — with an empty review body and seven
inline comments. Every comment is a maintainer DECISION answering the design
doc's own explicit "Open questions for the maintainer" section: where the Endo
ERTP layer lives (start in gateway, do not export), the expiry clock (lean on the
unconfined timer for now), whether to charge fees and rate limits (yes, both),
negative refund balances (allow), storage strategy (revisit broadly), and two
builder's-discretion / "no" calls.

Not a garden review-process miss. A design PR exists precisely to surface these
open questions and collect the maintainer's rulings; the review is the design
loop working as intended, and APPROVED confirms the proposal was accepted while
its open points were steered. No defect, style breach, missed edge case, or
standing convention failed to bind — there is nothing a panel seat, gate, or
instruction could have anticipated, because taste-and-scope adjudication of a
proposal is unanticipatable by definition. Same class as the earlier minion.town
(pr3/pr4/pr6) and endo (#123/#604/#631) maintainer-decision dismissals. The
primary job resolved all seven decisions in ff2aec7, replied to every thread,
verified green, and posted the conductor job — exactly right. See comment_url for
the verbatim review.
