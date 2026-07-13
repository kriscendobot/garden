---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr4-review-49e01038
verdict: not-a-miss
category: new-direction
pr: 4
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/4#pullrequestreview-4682580420
identity: kriscendobot/minion.town#4:review:4682580420:retro
producing_role: gardener
producing_job: build-minion-town-cd-github-workflow
severity: none
---

Paraphrase: the maintainer submitted a CHANGES_REQUESTED review on #4 whose body
was empty, carrying a single two-word inline directive on the newly-authored
provisioning script `deploy/aws/scripts/deploy-cd-iam.sh` — rewrite it in
JavaScript rather than bash, noting `zx` as an available option (verbatim at
`comment_url`). PR #4 adds a GitHub-Actions continuous-deployment workflow plus a
one-shot host-side script that provisions the GitHub OIDC provider and a
least-privilege IAM role.

**Grounds — not a review miss (language/taste direction, against the repo's own
standing convention).** The comment is a stylistic language preference — "port
this shell script to JS" — not a defect report. Nothing in the diff was wrong:
the builder authored `deploy-cd-iam.sh` as bash *deliberately to match the repo's
established script convention*, which the primary job's producer record
(`journal/jobs/tada/build-minion-town-cd-github-workflow.md`) states explicitly
("mirroring the repo's `common.sh` script style"). The project's deploy tooling is
a family of bash scripts (`common.sh`, `deploy-app.sh`, `deploy-oauth2-proxy.sh`,
`deploy-caddy.sh`, `deploy-www.sh`, `deploy-cd-iam.sh`); the new script followed
that convention idiomatically and passed its checks (`bash -n` clean, IAM policy
JSON validated). No juror-seat brief, skill, gate, or `roles/COMMON.md` /
minion.town standing instruction mandates JavaScript-over-bash — the garden itself
is a large bash codebase — so there was no written norm for any review surface to
enforce. The maintainer is *steering the codebase toward a new preference* (moving
provisioning scripts to JS/zx), first stated in this comment, i.e. the textbook
new-direction case. Even had a full gauntlet/panel run on #4 (it did not — this
was a project-repo build delivering a ready-for-review PR without a panel), no
seat would have flagged a correct, convention-following bash script as needing to
be JS; so this is not a `process` (missing-panel) miss either.

**Boundary note (auditable calibration, not a miss).** This clusters conceptually
with the other new-direction dismissals where the maintainer redirects
*already-correct work* on taste/scope grounds (e.g. #3's approve-and-merge
directive; endo-but-for-bots language/shape steers). The distinguishing test: the
work did not violate any convention that existed at authoring time — it *followed*
the repo's convention, and the maintainer is now changing that convention. That is
never a review miss. Recorded so a future retro on the same shape — a
"rewrite-in-language-X" style directive against an artifact that matched the
repo's then-current convention — is not re-litigated. No cluster minted; no
threshold to evaluate; no improvement job.
