---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Apply dckc's PR #2 review feedback to Oros-AI/oros-ckm-data-readiness #2 and #3

Repo: Oros-AI/oros-ckm-data-readiness (PR heads on the kriscendobot fork).
- PR #2: https://github.com/Oros-AI/oros-ckm-data-readiness/pull/2 (head `llm-erasable-syntax-lint`, base `ckm-poc-build`)
- PR #3: https://github.com/Oros-AI/oros-ckm-data-readiness/pull/3 (head `llm-erasable-syntax-apache`, same diff, ASF-process trailers — keep its `Generated-by:` / `Requested-by:` trailers and the disclosure section intact)

dckc's review on #2 (CHANGES_REQUESTED 2026-09-17, "Too long"), missed until now:
1. https://github.com/Oros-AI/oros-ckm-data-readiness/pull/2#discussion_r4042354163 — the CONTRIBUTING.md section is 5–10x too long; "1 or 2 sentences should do". Cut it to 1–2 sentences.
2. https://github.com/Oros-AI/oros-ckm-data-readiness/pull/2#discussion_r4042361155 — "Don't we already have a ci workflow? Do we need another?" Find the repo's existing CI workflow (check ckm-poc-build and the default branch). If one exists, add the `npm run typecheck` step to it and drop the new `.github/workflows/lint.yml`; if none exists, keep lint.yml and say why in the reply.

Apply the same change to BOTH PRs so they keep the same diff, as review-feedback follow-up commits. Reply in each review thread on #2 saying what changed, with the commit link. Update the PR #3 description's "What changed" bullets to match. Put 👀 on each thread first. Then comment on https://github.com/kriscendobot/garden/issues/112 with a short note that the feedback is applied (links to the commits).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-112
issue_url: https://github.com/kriscendobot/garden/issues/112#issuecomment-5818804304
submitter: dckc
----- END ISSUE NOTE -----
