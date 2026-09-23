---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr695-review-e6f842ee
verdict: not-a-miss
category: new-direction
pr: 695
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/695#pullrequestreview-4700861513
identity: endojs/endo-but-for-bots#695:review:4700861513:retro
producing_role: designer
severity: minor
grounds: >
  kriskowal (the repo owner and maintainer) submitted review 4700861513 on PR
  #695 with state CHANGES_REQUESTED. PR #695 is a DESIGN-DOC pull request
  (title "design(sturdy-refs): agent provide/accept surface"), authored by the
  garden's designer role — it touches only markdown under designs/, not code.
  The review redirects the design on three fronts, all of which are matters of
  the maintainer's own evolving, undocumented architectural intent rather than
  any written convention a review surface could hold: (1) it states the draft
  "pervasively assumes a sturdyref will be represented as a remotable, which is
  not my understanding of the current design direction," and then articulates
  the intended model for the first time — a sturdyref as a new KIND of passable
  value enlivened by a closely held capability (a nonce locator tracking the
  locator per sturdyref) so the daemon can use it as an anonymous placeholder
  for a pet-namèd formula; (2) it flags that "this notion may be flawed at the
  core," that a guest must not be able to locate/enliven an arbitrary sturdyref,
  and asks the author to "check the distributed confinement article" — an open
  research question about consistency with a distributed-confinement principle,
  which the maintainer himself hedges ("may be inconsistent"); (3) it raises
  retention/GC as a "potential blocker" needing an ephemeral GC retention edge
  and user-visible revocation, closing "Please explore this line of thought."
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  this feedback and concludes it could not have. The garden's gauntlet/panel is
  a CODE panel (breaker, typist, spec-keeper, corner-prober, &c.); no seat,
  skill, or standing instruction encodes the maintainer's target representation
  of sturdyrefs, nor can any seat independently adjudicate a design's
  consistency with an external "distributed confinement" article the maintainer
  is still reasoning about out loud. The PR's own history confirms this: no
  gauntlet/panel job for #695 exists in journal/jobs/tada/ (a design-doc PR runs
  no code gauntlet), and even had one run, its seats review code defects, not a
  design's fidelity to the maintainer's unwritten vision. The maintainer's
  hedged, exploratory language ("may be flawed at the core," "may be
  inconsistent," "Please explore this line of thought," "Please check the ...
  article") is the signature of DIRECTION-SETTING first stated in the comment,
  not of a caught error. Same class as the #123 finalization-directive and #604
  process-invocation dismissals in kind (maintainer steering, not a critique of
  a work product a panel could have pre-empted). The garden handled it
  correctly downstream: the primary job (pr695-review-e6f842ee) replaced the
  remotable-token design with first-class SturdyRef passable values, added
  confinement boundaries and retention/revocation requirements, and
  re-requested review — exactly the redirect asked for. Recorded as a durable
  dismissal so the same review is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #695 review 4700861513 (retro)

kriskowal (the repo owner) requested changes on PR #695 — a DESIGN-DOC PR
("design(sturdy-refs): agent provide/accept surface", markdown under designs/,
authored by the designer role). The review redirects the design: it says the
draft wrongly assumes a sturdyref is a *remotable* when "the current design
direction" makes it a new *passable value* enlivened by a closely held nonce
locator; it flags the whole notion as possibly "flawed at the core" against a
distributed-confinement principle the maintainer asks the author to go read; and
it raises GC-retention/revocation as an open line "to explore."

Not a garden review-process miss — new direction. All three fronts are the
maintainer's own evolving, undocumented architectural intent, stated here for
the first time, framed in explicitly exploratory language ("may be flawed at
the core," "may be inconsistent," "Please explore this line of thought"). The
garden's gauntlet/panel is a CODE panel whose seats catch code defects; no seat,
skill, or standing instruction holds the target representation of sturdyrefs or
can adjudicate a design's fidelity to an external distributed-confinement
article the maintainer is still reasoning through. No gauntlet ran for #695
(design-doc PRs run none), and one would not have caught this. Same class as the
#123/#604 maintainer-steering dismissals. Downstream the garden acted correctly:
the primary job swapped the remotable-token model for first-class SturdyRef
passable values and added the confinement/retention requirements. See
comment_url for the verbatim review.
