---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1125-review-af33f29e
verdict: not-a-miss
category: new-direction
pr: 1125
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
identity: endojs/endo-but-for-bots#1125:review:5240765072:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5240765072
review_at: 2026-09-17T19:55:02Z
severity: minor
grounds: |
  Not a review-miss. kriskowal's CHANGES_REQUESTED review 5240765072 on PR #1125
  (guest-owned invitation primitive) is a decomposition directive and names no
  defect in the diff. Paraphrased from untrusted text: split the PR into a stack
  (read-only directory attenuation, guests inviting further guests, special/pet
  names for freshly created agents, allowing for finer slices); retire #1125 and
  link the replacements; run a gauntlet and shepherd loop per new PR; divide the
  receipt line items across the stack layers and forward them as comments. The
  stated motivation is that the review scroll-back had grown too deep for
  effective review. He adds a forward-looking wish that the fleet be more
  proactive about anticipating a stack split when a PR's scope outgrows its bounds.

  That wish is a requirement first stated in this review. No seat brief, skill,
  or COMMON.md norm encodes "split a PR once its review history or scope grows
  too large" (grep of roles/ and skills/ for split/stack/scope-growth guidance
  finds nothing binding), and scope-slicing is a maintainer workflow decision,
  not something a code-panel seat judges. The precedent is the #127
  decomposition directive (endojs-endo-but-for-bots-pr127-2d156fdf), which was
  dismissed as new-direction. Not evaluator-gaming: nothing the review measures
  moved. The panel ran (six rounds, review-budget-reached), and scope growth came
  from maintainer-requested additions (pins/nets/options, dismissed retros
  4e1469ed and b58d5a3f), not from the producer routing around review.

  World check (not the primary's claim): #1125 is CLOSED, and the replacement
  stack #1304 (1/3 read-only dir attenuation), #1306 (2/3 pins/networks/names for
  new agents), and #1305 (3/3 guest-owned invitation) exist, reference #1125, and
  are all MERGED. The orchestration split-pr1125-stack-gauntlets plus its
  -resume completed the per-PR gauntlet+shepherd children. The deliverable exists.

  Forward note (not a cluster): the proactive-split wish plus the receipt
  line-item forwarding mechanics could become a design or builder improvement to
  the producing workflow (for example, a gauntlet/fix-loop signal that suggests a
  stack split after N review rounds or a scope-growth threshold). This belongs to
  maintainer/liaison steering, not the review-miss store, so I dispatched no job.
---

Dismissal: the #1125 stack-split directive is a maintainer scope/decomposition
decision plus a first-stated wish for proactive splitting. No existing review
rule could have caught it. The split stack exists and was merged.
