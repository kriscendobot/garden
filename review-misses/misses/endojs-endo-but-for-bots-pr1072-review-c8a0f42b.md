---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1072-review-c8a0f42b
verdict: miss
category: spec-violation
pr: 1072
cluster: related-design-contract-cross-check
cluster_pattern: A design or review-feedback edit states a protocol or wire-format rule that contradicts an already-landed authoritative design in the same repository, because the producing and review paths do not cross-check related design contracts before presenting the change to the maintainer.
review_at: 2026-08-30T04:00:21Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1072#pullrequestreview-5059889251
identity: endojs/endo-but-for-bots#1072:review:5059889251
producing_role: gardener
producing_job: endojs-endo-but-for-bots-pr1072-review-73226ec0
missed_by: spec-keeper and integrator related-design cross-check
severity: moderate
grounds: |
  The reviewed design put OCapN connection hints in URL query parameters, but
  the repository's authoritative designs/daemon-locator-reference.md had, since
  commit 5bd2f09d6 on 2026-06-25, specified @-delimited path components and
  explicitly reserved query parameters for alleged attributes. The canonical
  document was present unchanged at the reviewed commit da0428084. This was
  therefore an existing protocol contract, not syntax or taste first introduced
  by the maintainer's review.

  PR #1072 was still draft and no gauntlet or panel had run; that absence is
  consistent with the manual-gauntlet workflow and is not evaluator avoidance.
  The miss instead arose in the preceding review-feedback job, which translated
  an earlier design suggestion into query-string syntax without reconciling the
  related locator design, and in the lack of a related-design contract check
  before the draft reached the maintainer again. A spec-keeper or integrator
  cross-check against the repository's authoritative locator design should have
  caught the contradiction. The defect was caught before merge, so severity is
  moderate rather than major.
---

The maintainer pointed out that the revised OCapN-Noise locator example encoded
connection hints in the wrong URL component. The repository's established
locator design already placed hints in ordered path components and reserved the
query string for asserted attributes. The primary feedback job subsequently
aligned the design with that existing contract in commit `8e3e7ef62` and replied
on the review thread. This record paraphrases the issue; re-fetch `comment_url`
for the untrusted verbatim review.
