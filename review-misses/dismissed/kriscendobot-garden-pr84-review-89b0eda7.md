---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr84-review-89b0eda7
verdict: not-a-miss
category: new-direction
pr: 84
repo: kriscendobot/garden
identity: kriscendobot/garden#84:review:5119827342:retro
comment_url: https://github.com/kriscendobot/garden/pull/84#pullrequestreview-5119827342
review_at: 2026-09-05T04:51:04Z
severity: minor
grounds: |
  Maintainer decision on an explicit design open question — new direction, not a
  review-process miss. PR #84 (design: the groom role + open questions) is the
  designer's open-questions carve-out review PR: the role brief, manifest fix, and
  CLAUDE.md inventory add already landed bare on main2, and the PR body carries the
  `<!-- garden-design-open-questions -->` marker whose documented purpose (CLAUDE.md
  § Conventions carve-out; designer AGENT.md § Operating norms) is to give the
  maintainer an inline surface to DECIDE forward commitments the designer explicitly
  deferred. Open question #1 asked, verbatim in the diff, whether to fold the four
  v1 skills into the role brief (the design's recommendation) or mint dedicated
  `SKILL.md` files for velocity-recalibration/roadmap-projection. In review
  5119827342 (APPROVED) the maintainer answered that question — two inline comments
  on designs/groom-role.md paraphrasable as "fold these in" and "dedicated skills,
  please" — plus the disposition "address feedback and conduct, then dispatch a
  builder." That is the maintainer exercising the exact taste/scope decision the PR
  was built to elicit, first expressed in this review. No juror seat, gate, or
  standing instruction encodes a preference for minting-vs-folding a role's helper
  skills — that is a design-taste call the panel cannot and should not pre-empt — so
  nobody could have anticipated which way the maintainer would rule.

  Not evaluator-gaming/avoidance. The absence of a design-panel gauntlet in
  journal/jobs/tada for this PR is BY CONVENTION, not a routed-around evaluator: the
  `garden-design-open-questions` marker suppresses the design panel precisely because
  the content already lives on main2 and the PR is a maintainer answer-surface, not a
  pending merge (CLAUDE.md § Conventions). So this is not the
  `garden-design-pr-gauntlet-bypass` shape — the gauntlet did not skip a review it was
  owed. The measurement did not move while the target stood still.

  Primary genuinely delivered (not a no-op). The primary/design-feedback jobs pushed
  commit 620d94d91f ("docs(groom): resolve dedicated skill design (#84)", touching
  designs/groom-role.md + roles/groom/AGENT.md) to the PR head branch
  origin/groom-role-open-questions and posted two reply comments (reviews 5120458056,
  5120458165) confirming the design now mandates dedicated SKILL.md files with builder
  acceptance criteria. The directive deliverable exists in the world — verified on the
  head branch, not merely asserted. One observation for the primary loop (not a review
  miss and outside this retro's scope): 620d94d91f is NOT an ancestor of main2 (main2
  still carries the folded design at designs/groom-role.md), and PR #84 remains OPEN;
  landing the resolved design onto main2 and dispatching the promised builder to mint
  the skills is conduct/build follow-up owned by the primary chain, not the review
  process.
---

Maintainer review 5119827342 (APPROVED) on PR #84 answers the design's explicit
open question #1 — choosing dedicated SKILL.md files over the design's folded
recommendation ("fold these in" / "dedicated skills, please") — and asks to
address feedback, conduct, and dispatch a builder. PR #84 is the designer
open-questions carve-out, whose whole function is to elicit exactly this maintainer
decision; the design-panel gauntlet is intentionally suppressed by the
`garden-design-open-questions` marker, so no evaluator was routed around. This is
forward direction/taste first stated in the review, not a review-process miss — a
dismissal. The primary genuinely delivered (commit 620d94d91f on head branch
groom-role-open-questions plus two reply comments). Re-fetch the verbatim review
body and inline comments at comment_url.
