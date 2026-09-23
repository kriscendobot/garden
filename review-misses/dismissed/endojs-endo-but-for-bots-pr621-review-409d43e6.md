---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr621-review-409d43e6
verdict: not-a-miss
category: new-direction
pr: 621
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/621#pullrequestreview-4672880146
identity: endojs/endo-but-for-bots#621:review:4672880146:retro
producing_role: designer
producing_job: gauntlet-endo-but-for-bots-pr621-endoclaw-oauth
missed_by: design-panel
severity: minor
grounds: >
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  kriskowal's CHANGES_REQUESTED review 4672880146 on #621 and concludes it could
  not have: all three of its inline comments are forward design direction on a
  DESIGN-ONLY PR, each a first-stated maintainer decision, taste, or scope
  expansion rather than a defect the design panel let ship. #621 is
  "design: refine endoclaw-oauth as the connector credential foundation", a
  design-only PR editing designs/endoclaw-oauth.md, and it DID run the full
  gauntlet: a 7-seat design panel (critic, skeptic, decomplector, ergonomist,
  copyeditor, pedant, novice), a fixer round, and a PASS re-review, per
  jobs/tada/gauntlet-endo-but-for-bots-pr621-endoclaw-oauth.md. The three comments,
  paraphrased from the primary loop (jobs/tada/endojs-endo-but-for-bots-pr621-review-409d43e6.md):
  (1) comment 3560153009 asks to POST A JOB to plan adding stream()/bytes()
  accessors, gated on progress on passable byte arrays; (2) comment 3560264811 asks
  to POST A JOB to plan the gateway OAuth flow as separate-but-coherent
  AWS/CloudFlare/Netlify Endo Gateway narratives, starting from the maintainer's own
  minion.town exploration; (3) comment 3560276326 directs revising Open Question 2
  to cast client registration as an endowable OAuth client registrar capability
  supplied by a deployment (a gateway like minion.town, or the Familiar), not the
  Daemon. Dispositive structural reason grounded in the PR's own history: the
  gauntlet report records that the binary-media bytes() gap AND the two Open
  Questions were DELIBERATELY DEFERRED and recorded in the design doc itself, the
  Open Questions "left deferred per the job spec (not reopened)". So (1) is the
  maintainer asking to plan a surface the panel already flagged and correctly
  deferred; (3) is the maintainer ANSWERING a deferred Open Question with his own
  preferred design; (2) is forward direction seeded by the maintainer's own
  minion.town work and a provider-specific three-way split nobody could have
  predicted. Each of the three is the exact class as the #631 dismissal (the
  maintainer disposing of a surfaced open question) and the #611/#604/#288
  design-doc new-direction dismissals: a design panel that flags a gap or open
  question and defers it to the maintainer is doing precisely its job; it cannot
  preempt how the maintainer chooses to answer it or which forward work he requests.
  No standing garden rule bound and failed to fire, so the severity-bypass
  precondition (a rule that existed and did not bind) is absent. Not a garden
  review-process miss; new direction. Recorded as a durable dismissal so the same
  review is never re-litigated. No cluster minted; no threshold; no improvement
  dispatched.
---

# Dismissal: endo-but-for-bots #621 review 4672880146 (retro)

kriskowal's CHANGES_REQUESTED review on #621 (a design-only PR refining
designs/endoclaw-oauth.md as the connector credential foundation) carried an empty
body and three inline comments, all forward design direction:

1. Plan-a-job request for `stream()`/`bytes()` fetch accessors, gated on progress on
   passable byte arrays.
2. Plan-a-job request for the gateway OAuth flow as separate-but-coherent
   AWS / CloudFlare / Netlify Endo Gateway narratives, seeded by the maintainer's own
   minion.town exploration.
3. A doc-revision directive to recast Open Question 2's client registration as an
   endowable OAuth client registrar capability supplied by a deployment (a gateway
   such as minion.town, or the Familiar), not the Daemon.

Not a garden review-process miss. #621 ran the full gauntlet (a 7-seat design panel,
a fixer round, and a PASS re-review). The gauntlet DELIBERATELY deferred the
binary-media `bytes()` gap and both Open Questions, recording them in the design doc
per the job spec. Comment 1 asks to plan the very surface the panel flagged and
deferred; comment 3 is the maintainer answering a deferred Open Question with his own
preferred design; comment 2 is forward direction seeded by the maintainer's own
minion.town work with a provider-specific split nobody could anticipate. A design
panel that flags a gap or open question and defers it to the maintainer is doing
exactly its job; it cannot preempt the maintainer's answer or the forward work he
requests. This is the same class as the #631 dismissal (maintainer disposing of a
surfaced open question) and the #611/#604/#288 design-doc new-direction dismissals.
No standing rule bound and failed. New direction, not a miss. See comment_url for the
verbatim text.
