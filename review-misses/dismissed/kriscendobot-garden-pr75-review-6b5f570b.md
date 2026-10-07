---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr75-review-6b5f570b
verdict: not-a-miss
category: new-direction
pr: 75
review_at: 2026-09-30T02:38:06Z
repo: kriscendobot/garden
comment_url: https://github.com/kriscendobot/garden/pull/75#pullrequestreview-5360848681
identity: kriscendobot/garden#75:review:5360848681:retro
surface: pr-review-body
author: kriskowal
producing_role: designer
producing_job: design-american-english-panel
severity: minor
grounds: |
  The APPROVED review has no inline comments and gives lifecycle direction for
  an already-implemented design: preserve the design as the accepted record and
  do not start another build. It names no bug, style or specification violation,
  missed edge case, or standing convention that a panel seat or gate should
  have caught. The reviewed document already said the system was implemented
  and subagent-tested, and that the answer-surface PR remained open in the
  interim under the maintainer's earlier directive. Deciding that the interim
  was over, approving the record, and declining duplicate implementation are
  maintainer decisions first stated in this review.

  The absence of a panel is the documented path, not evaluator avoidance. PR
  #75 carries the garden-design-open-questions marker; its content had already
  landed on main2, and the garden-own-repo carve-out explicitly makes this PR a
  maintainer answer surface that owes no gauntlet. The PR history contains the
  earlier maintainer decisions, the implementation completion report, and this
  approval, but no panel review or gauntlet job. The intended evaluator was the
  maintainer, and it ran.

  The primary's deliverable exists independently of its report. Commit
  15d64fc4e8c on main2 changes the design status from interim to built and
  captured, marks the build plan executed, and records ongoing curation instead
  of an open PR. GitHub reports PR #75 merged on 2026-09-30. There is no false
  no-op discrepancy. This is approval and workflow direction, so it mints no
  cluster and warrants no review-improvement job.
---

# Dismissal: approval to capture an already-built design

The maintainer approved the American-English normalization design, directed the
garden to retain it as the accepted record, and said not to repeat the build
because the designed system already existed. This is a bot-authored paraphrase;
the untrusted review text remains available only at `comment_url`.

The design-answer-surface exception intentionally skipped the gauntlet, and the
PR's history shows that the maintainer supplied the decisions this surface was
created to collect. The capture update is on `main2`, and the PR is merged. This
is new lifecycle direction, not a review-process miss.
