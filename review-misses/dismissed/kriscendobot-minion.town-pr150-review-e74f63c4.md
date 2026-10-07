---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr150-review-e74f63c4
verdict: not-a-miss
category: new-direction
pr: 150
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/150#pullrequestreview-5407344186
identity: kriscendobot/minion.town#150:review:5407344186:retro
review_at: 2026-10-04T17:30:42Z
producing_role: builder
severity: minor
grounds: |
  Not a review miss. The maintainer approved PR #150 and requested a separate
  follow-up migration from shell scripts to JavaScript plus a JavaScript-only
  policy for future Minion Town scripts. The review identified no defect in the
  reviewed change and explicitly put the conversion in later work. This was a
  repository-wide implementation preference and scope expansion first stated
  in the review, not a bug, convention, specification, or edge case that the
  panel should already have caught.

  The actual history rules out a skipped evaluator. Three panel rounds had run
  before the maintainer review, at commits f77663c0, 6dd243ba, and b93d8452.
  Those rounds examined deploy-app.sh in detail, including shell robustness and
  production-smoke semantics, but no standing JavaScript-only rule existed at
  the reviewed fa7b1145 head. The PR modified one of an established collection
  of shell deployment scripts. Later panel rounds continued reviewing that
  implementation rather than treating the language choice as a violation. The
  maintainer's wording and the separate-follow-up shape therefore introduced
  direction rather than exposing evaluator gaming or a missed binding rule.

  World check independent of the primary report: the requested follow-up
  exists. The serial orchestration minion-town-shell-to-js-20261004 completed
  all three children, which opened PRs #151 through #154; their journal records
  include the corresponding gauntlets. However, the primary also claimed it
  had durably added the policy to projects/minion-town/README.md, while the
  current journal2 file is one blank line. The in-repo policy is present only
  on still-open PR #151, so that specific immediate-policy claim no longer
  matches the world. This discrepancy concerns execution of the new directive,
  not whether PR #150's earlier review should have anticipated it.
---

Dismissed as new direction. The maintainer approved the PR and asked for a
separate, repository-wide language migration and future authoring policy. This
record paraphrases the untrusted review; the source text remains at
`comment_url`.
