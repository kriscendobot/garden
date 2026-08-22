---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---
# Merge current upstream master into the endo-but-for-bots `llm` branch

Maintainer directive context: endojs/endo-but-for-bots PR #719 has now merged upstream. Integrate the resulting current `endojs/endo` `master` into the `llm` roadmap branch of `endojs/endo-but-for-bots`.

Work in the isolated project checkout keyed by this job. Fetch both current upstream `master` and the fork's current `llm`, create a fresh date-qualified integration branch from `llm`, and merge upstream `master` as a true merge commit that preserves both histories. Do not rewrite or recreate the fork's `master` mirror. Resolve conflicts faithfully: retain deliberate `llm` divergences and take upstream where `llm` has no conflicting intent. Document every notable or non-obvious conflict resolution. If `yarn.lock` needs regeneration, keep its mechanical update in a separate commit per `skills/yarn-lock-separate-commit/SKILL.md`.

Push the integration branch, open a PR against `llm` through the job-scoped `ensure-pr.sh` helper, and drive the PR to green and mergeable. Run proportionate local verification and report the exact commands and results. When CI is green and the PR is mergeable, merge it into `llm` with merge history preserved, then confirm the resulting `llm` head contains the upstream merge and report its post-merge check state. If the integration cannot safely converge, leave the PR open and report the specific blockers instead of forcing a bad merge.

Source context: https://github.com/endojs/endo-but-for-bots/pull/719
