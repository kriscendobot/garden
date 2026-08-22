---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1040-review-4b910966
verdict: not-a-miss
category: new-direction
pr: 1040
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1040#pullrequestreview-4986825748
identity: endojs/endo-but-for-bots#1040:review:4986825748:retro
producing_role: builder
producing_job: mirror-hardened262-endo-but-for-bots
review_at: 2026-08-20T19:57:11Z
missed_by: none
severity: minor
grounds: >
  kriskowal (repo owner and maintainer) left review 4986825748 (state COMMENTED,
  empty body) carrying a single inline comment on
  packages/hardened262/baseline.json: paraphrased, "this is good, but an
  alternative that would be more legible in diffs would be directories containing
  flat, textual lists." I re-fetched the review and its comments read-only in
  this retro to ground the verdict in the world, not the primary report: the one
  inline comment above is the entire feedback, and the primary's deliverable is
  real and merged — commit ae296e0d0 ("refactor(hardened262): split baseline
  into text lists (#1040)") removed baseline.json and added the per-scenario
  baseline/<agent>/<mode>/{passed,failed,skipped}.txt tree, and PR #1040 is
  MERGED. So the primary loop genuinely addressed the ask; this second loop only
  judges whether the review process should have anticipated the preference.
  It could not have, for three grounds. (1) The comment is an explicit
  affirmation, not an indictment: the maintainer opens with "this is good" —
  the monolithic JSON baseline was correct, not a bug, spec violation, missed
  edge case, or violated convention. It is a diff-ergonomics preference offering
  "an alternative." (2) No standing rule bound: a repo-wide grep of every juror
  seat brief and skill for a diff-legibility / flat-text / newline-delimited /
  one-per-line convention returns nothing, so no seat, gate, or COMMON.md norm
  demanded directories-of-text over JSON for test-outcome baselines. (3) No
  in-repo precedent to apply: the sibling instrument packages/test262-runner
  stores no baseline/expectations file at all (it does live xs-parity
  comparison), and this package faithfully MIRRORED endojs/endo's upstream
  harness, which itself used baseline.json — an explicit, documented porting
  choice in the PR body, not an oversight. The preference for a diff-legible
  layout of a generated baseline is first stated in this comment; nobody could
  have anticipated it. Textbook new direction / taste. No cluster minted; no
  improvement dispatched. Recorded durably so the same review is never
  re-litigated.
---

# Dismissal: endo-but-for-bots #1040 review 4986825748 (retro)

kriskowal (repo owner) left one inline comment on
packages/hardened262/baseline.json in review 4986825748: paraphrased, the JSON
baseline is good, but a more diff-legible alternative would be directories
containing flat, textual lists.

Not a garden review-process miss — new direction / taste. The comment opens with
an explicit affirmation ("this is good"): the JSON baseline was not a defect,
spec violation, missed edge case, or violated convention, so there was nothing
for a panel seat, gate, or standing instruction to catch ahead of the
maintainer. It offers a diff-ergonomics alternative, stated for the first time
in this comment. Three grounds confirm no review surface could have anticipated
it: no juror seat brief or skill encodes any diff-legibility / flat-text /
one-per-line convention (repo-wide grep is empty); the sibling instrument
packages/test262-runner stores no comparable baseline file (it does live parity
comparison), so there was no in-repo precedent to enforce; and this package
faithfully mirrored endojs/endo's upstream harness, which used baseline.json —
a documented porting choice in the PR body, not an oversight.

Grounded in the world, not the primary report: the primary's fix is real and
merged. Commit ae296e0d0 ("refactor(hardened262): split baseline into text
lists") removed baseline.json and added the per-scenario
baseline/<agent>/<mode>/{passed,failed,skipped}.txt tree, and PR #1040 is
MERGED — so the single-loop response genuinely landed the maintainer's
preferred layout. Same class as prior maintainer taste/new-direction
dismissals. No cluster minted; no improvement dispatched. See comment_url for
the verbatim comment.
