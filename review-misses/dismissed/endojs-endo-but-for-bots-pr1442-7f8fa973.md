---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1442-7f8fa973
verdict: not-a-miss
category: new-direction
pr: 1442
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1442:comment:6175103465:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1442#issuecomment-6175103465
review_at: 2026-10-14T18:11:20Z
severity: minor
grounds: |
  This is a maintainer experiment directive, not an indictment of the diff.
  The bot had explained, in answer to the upstream packaging question on
  endojs/endo#3372, that the configstore/nconf resolutions were unrelated to
  the SES fix but needed so Yarn's fork-PR hardened mode would install
  (YN0078). The maintainer (kriskowal) quoted that answer and asked the bot to
  remove the overrides and run CI to show they were superfluous. The request
  tests a hypothesis the maintainer first stated in this comment. It names no
  defect a seat brief, skill, or standing rule covers.

  The world shows the hypothesis was wrong, so no defect slipped past review.
  The primary removed the overrides on trial head d75cf0acfb, and CI run
  38613425846 failed 12 of 12 install-dependent jobs with YN0078. The primary
  restored head eec274bad8, CI went green, and bot comment at
  2026-10-14T18:16:08Z posted the evidence. The primary's report matches the
  PR thread; it did not close as a false no-op. The overrides left the PR
  later only because upstream master landed the CI fix underneath. On the
  maintainer's later request, the rebase (head 5091b254cc) dropped them and
  left the SES change as the sole commit.

  The review process ran: pr1442 gauntlet clean/viability/panel/fix/shepherd
  jobs are in journal/jobs/tada/, so this is not avoidance or
  evaluator-gaming. A scope-bundling objection (three changes in one PR)
  would also be weak. The bundling was a deliberate mirror of upstream #3372,
  and the body disclosed and justified each part. Second retro on #1442
  dismissed; the sibling 69bf491a was also a new-direction dismissal.
---
Dismissed: the maintainer asked the bot to remove the dependency overrides
and use CI to test whether they were superfluous. That was a first-stated
experiment, not a missed defect, and the CI trial showed the overrides were
required (YN0078) until upstream fixed CI underneath.
