---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr108-c377ece2
verdict: not-a-miss
category: new-direction
pr: 108
repo: kriscendobot/garden
identity: kriscendobot/garden#108:comment:5798546568
comment_url: https://github.com/kriscendobot/garden/pull/108#issuecomment-5798546568
review_at: 2026-09-23T16:24:14Z
severity: minor
grounds: |
  Scope/packaging direction first stated in the comment. PR #108 was a
  designer answer-surface PR under the CLAUDE.md "design carrying open
  questions gets a review PR" carve-out, marked
  <!-- garden-design-open-questions --> so that, by design, no design panel is
  staged for it (the content was already on main2). No gauntlet/panel job for
  pr108 appears in journal/jobs/tada/, and none should have: the carve-out makes
  the maintainer the reviewer. That is not avoidance-style evaluator gaming,
  because no evaluator was supposed to run. The PR originally bundled two
  unrelated designs (Opus 5.5 tier placement and TypeSafe Jev for
  classification). The maintainer asked for one PR per topic. No standing rule
  requires one design topic per design PR: the designer brief, pr-formation,
  and pr-creation-flow only require designs and their implementations to be
  separate PRs, and the packager seat's conflated-commit line covers
  commit-level diff hygiene in code panels, not bundled design topics. So this
  preference was first stated here. A single instance does not justify a new
  cluster. If it recurs, mint a "design-pr-one-topic" process cluster and add a
  designer-brief rule.

  Primary deliverable verified in the world, not taken from the primary report:
  PR #108 is now titled "design: Opus 5.5 tier placement (open questions)" and
  its body links the split. The Jev topic lives in kriscendobot/garden#109,
  which is merged. main2 commit bf3a621b768 is "docs: split Opus 5.5 and Jev
  designs". There is no false-no-op discrepancy to report.
---

The maintainer asked for PR #108, which combined the Opus 5.5 tier-placement
design and the TypeSafe Jev design, to be split into one pull request per
topic. No written garden rule requires one topic per design PR, and
open-questions design PRs deliberately skip the panel. That makes this new
scope/packaging direction, not a review-process miss. The primary did the split
(PR #109 is merged, and #108 now covers only Opus 5.5). Re-fetch the verbatim
comment at comment_url.
