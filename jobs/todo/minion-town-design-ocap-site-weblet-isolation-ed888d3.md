---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: `kriscendobot/minion.town` (bare clone `worktrees/kriscendobot-minion.town.git`).
Branch `design/ocap-site-weblet-isolation` (head `ed888d3`, one commit `docs: design ocap.site weblet isolation`, adding `designs/ocap-site-weblet-isolation.md`, 325 lines) is pushed but has **no pull request** — verified with `gh pr list --state all` on the repo. A design that lands on a branch and never opens a PR gets no review and no build.

Task: open the PR for this branch and run it through the full gauntlet.
1. Rebase `design/ocap-site-weblet-isolation` on the current default branch if it has fallen behind (its parent is `bc4ef70` "fix(deploy): wire weblet publishing into CD").
2. Open a **draft** PR from `design/ocap-site-weblet-isolation`, titled for the design (`docs: design ocap.site weblet isolation`), body summarizing the decision: publish each weblet at `<hash>.ocap.site`, submit `ocap.site` to the PSL PRIVATE section on meeting admission criteria, apex is a stateless redirect to `https://minion.town/`, no authenticated app/API/user state under `ocap.site`. Note that it makes no DNS, certificate, deployment, or PSL change yet, and that it follows the direction in `https://github.com/kriscendobot/garden/issues/58#issuecomment-5245282293`.
3. Run the gauntlet end to end per [pr-creation-flow](skills/pr-creation-flow/SKILL.md): clean → panel review → fix-loop → un-draft. This is a **design-only, docs-touching** change — expect the panel's kind discrimination to seat the design/docs jurors, not the source-touching set.
4. Do not implement the design in this job; a build is a separate follow-up once the design PR is reviewed and merged.
