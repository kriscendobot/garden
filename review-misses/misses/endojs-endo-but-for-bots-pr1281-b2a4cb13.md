---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1281-b2a4cb13
verdict: miss
category: docs-drift
pr: 1281
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1281#issuecomment-5701105623
identity: endojs/endo-but-for-bots#1281:comment:5701105623:retro
review_at: 2026-09-16T16:42:51Z
producing_role: builder
producing_job: ses-node26-lockdown-permits
missed_by: integrator (§ Merge-commit readability, template clause) across six code-panel rounds; no deterministic PR-body-vs-template check at PR-open or panel stage
severity: minor
cluster: pr-description-reviewer-attention
---

# Miss: PR #1281 body ignored the upstream PR template through six panel rounds

The maintainer asked, paraphrased (verbatim untrusted text at `comment_url`), that
the PR's title and description be brought into line with the upstream GitHub PR
template. The primary (`endojs-endo-but-for-bots-pr1281-b2a4cb13`) did so: the
body edit history shows the rewrite at 2026-09-16T16:46:10Z, and the current body
carries the template's Refs line, `## Description`, and the six
`### … Considerations` headings. Deliverable confirmed in the world, not just in
the primary's report.

## Grounds (miss)

The rule was standing and specific, not first stated in the comment.
`skills/pr-formation/SKILL.md` § "Use the upstream template, section for section"
tells the PR-open step to fetch `.github/PULL_REQUEST_TEMPLATE.md` from the base
branch and fill its headings verbatim; `skills/pre-pr-checklist/SKILL.md` repeats
it. The template exists on both the PR's base (`master-aaf9ea4`, an upstream
`endojs/endo` master snapshot) and `llm`. The PR was upstream-bound from birth
(its own Provenance section said it was based on upstream master so it could be
carried upstream cleanly), yet the body as opened on 2026-09-15 and as re-edited
at 01:32Z used invented sections ("Goal", "What was noisy", …) and none of the
template's headings.

Review demonstrably had the chance and the rule: `journal/jobs/tada/` holds the
`ses-node26-lockdown-permits-gauntlet` record with panel rounds 1–6 and fixer
rounds 1–5, all before the comment. The integrator seat sat on those panels and
its brief's Merge-commit readability axis asks, in so many words, whether the
description follows the project's GitHub PR template. The integrator did invoke
that very axis (a should-fix about the title naming only half the change), but
never flagged the non-template body. So a seat-brief line existed and did not
bind — the sensing half of the cluster pattern: a skill governs authoring the PR
prose, but nothing *reliably* reviews the produced body against it.

Distinguished from the #1099 dismissal (`dismissed/endojs-endo-but-for-bots-pr1099-e2aa4377.md`):
there no panel had run and the ask was a forward ferry-prep transition; here the
gauntlet had completed six rounds on an upstream-based PR and the defect was a
convention the panel's own seat is charged to check.

Clustered with `pr-description-reviewer-attention` (agoric-sdk #16 ×2): same
root cause — garden-authored maintainer-facing PR prose violates its authoring
skill and no review stage checks the produced artifact — and the cluster's
minting record already named template non-conformance (agoric-sdk PR-7) as the
same family.
