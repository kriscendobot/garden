---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr87-review-b6c21549
verdict: not-a-miss
category: new-direction
pr: 87
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#87:review:5273122355:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/87#pullrequestreview-5273122355
review_at: 2026-09-22T00:26:00Z
severity: minor
grounds: |
  Test-framework direction first stated in the comment, then reversed by the
  maintainer. CHANGES_REQUESTED review 5273122355 (kriskowal, zero inline
  comments) asked that PR #87 (feat(claude): wire the Claude-agents capability
  behind ENDO_CLAUDE_ENABLED) use ava for its tests. The PR's six new test files
  (test/claude-*.test.ts) were written against vitest, which was and still is the
  repo's established runner: package.json has run `vitest run` with a vitest
  devDependency since the repo's first commits (June/July 2026), and it never
  depended on ava. The producer followed the repo's own convention. No juror seat,
  skill, or standing instruction says minion.town must use ava, so the panel had
  nothing to enforce. A standing rule would have favored the vitest the PR
  already used.

  The world confirms the direction was never binding. At 02:39:55Z the same day,
  maintainer issue-comment 5770443815 superseded it with a repo-wide move to
  vitest ("the Endo repository dictates house style"). Bot comment 5770657287
  acknowledged the reversal. The PR merged at 03:13:57Z as commit 287af35b, with
  vitest still in package.json. The primary job (b6c21549) closed as a no-op
  after checking all of this. I re-verified it against the PR and the comments,
  so there is no false no-op to report.

  This is not a process miss: the gauntlet ran on #87 before it was un-drafted
  and merged, and nothing in it could bind on a runner choice that no rule
  specifies. It is not evaluator-gaming either, because no measurement moved.
---

Maintainer review 5273122355 on PR #87 asked that the house test framework, ava,
be used instead of the vitest the PR's tests were written in. vitest was already
minion.town's established runner, and no garden rule names ava for this repo. The
maintainer reversed the ask about two hours later in favor of a repo-wide move to
vitest, and the PR merged on vitest. This was a new direction that was later
withdrawn, not a review-process miss, so it is dismissed. Re-fetch the verbatim
review body at comment_url.
