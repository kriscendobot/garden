---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr621-review-659246fc
verdict: not-a-miss
category: new-direction
pr: 621
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/621#pullrequestreview-4673297710
identity: endojs/endo-but-for-bots#621:review:4673297710:retro
producing_role: designer
producing_job: gauntlet-endo-but-for-bots-pr621-endoclaw-oauth
missed_by: design-panel
severity: minor
grounds: >
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  kriskowal's COMMENTED review 4673297710 on #621 and concludes it could not
  have: the review is a single forward-design directive on a DESIGN-ONLY PR,
  asking for a NEW design round plus a first-stated architectural enrichment
  nobody had proposed, not a defect the design panel let ship. #621 is a
  design-only PR refining designs/endoclaw-oauth.md on the llm roadmap branch
  (head design/endoclaw-oauth-foundation), and it DID run the full gauntlet: a
  7-seat design panel (critic, skeptic, decomplector, ergonomist, copyeditor,
  pedant, novice), a fixer round, and a PASS re-review, per
  jobs/tada/gauntlet-endo-but-for-bots-pr621-endoclaw-oauth.md. Paraphrased from
  the primary loop (jobs/tada/endojs-endo-but-for-bots-pr621-review-659246fc.md,
  which enumerated the whole review and found the body is the sole unit of work,
  zero inline comments): the maintainer observes the current design presumes a
  capability plus a dynamic "caretaker" controller facet, and directs a further
  design round that ALSO lets a capability holder recursively PARTITION and
  DELEGATE, optionally minting a child capability + controller facet, subject to
  a MONOTONE narrowing invariant (child authority never expands beyond parent).
  He further asks to CAPTURE this as a named, reusable design pattern in a design
  skill: composite "caretaker attenuation" (the caretaker pattern + attenuation).
  Dispositive structural reason grounded in the PR's own history: this is a
  design-space ENRICHMENT the maintainer is originating, an unforeseeable
  architectural direction (recursive capability delegation with a monotonicity
  invariant) first stated in this review, not a gap the panel flagged and
  shipped anyway. A design panel reviewing an existing design doc for
  correctness, coherence, and clarity is not expected to invent the maintainer's
  preferred capability-model extension or to coin the pattern name he wants;
  doing so would be preempting his design authority, not reviewing it. Same class
  as the SIBLING dismissal on this very PR (review 4672880146, dismissed as
  new-direction) and the #631 / #611 / #604 / #288 design-doc new-direction
  dismissals: forward maintainer direction on a design-only artifact. No standing
  garden rule bound and failed to fire, so the severity-bypass precondition (a
  rule that existed and did not bind) is absent. Not a garden review-process
  miss; new direction. Recorded as a durable dismissal so the same review is
  never re-litigated. No cluster minted; no threshold; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #621 review 4673297710 (retro)

kriskowal's COMMENTED review on #621 (a design-only PR refining
designs/endoclaw-oauth.md as the connector credential foundation) carried its
directive in the review body with no inline comments. Paraphrased: the current
design presumes a capability plus a dynamic "caretaker" controller facet that can
adjust attenuation on the fly; the maintainer directs a further design round that
also lets a capability holder recursively partition and delegate, optionally
minting a child capability + controller facet, under a monotone narrowing
invariant (child authority never expands beyond parent). He additionally asks to
capture this as a named, reusable design pattern in a design skill: composite
"caretaker attenuation."

Not a garden review-process miss. #621 ran the full gauntlet (a 7-seat design
panel, a fixer round, and a PASS re-review). The review originates a new design
direction — recursive capability delegation with a monotonicity invariant — first
stated here, and requests naming a reusable pattern. A design panel reviewing an
existing design doc cannot be expected to invent the maintainer's preferred
capability-model extension or coin the pattern name he wants; that is his design
authority, not a defect the panel let ship. This is the same class as the sibling
dismissal on this same PR (review 4672880146) and the #631 / #611 / #604 / #288
design-doc new-direction dismissals: forward maintainer direction on a design-only
artifact. No standing rule bound and failed. New direction, not a miss. See
comment_url for the verbatim text.
