---
role: builder
repo: kriscendobot/minion.town
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Move minion.town CD (deploy.yml) onto the ci.minion.town runner during the billing block

**Maintainer authorization:** kriskowal on https://github.com/kriscendobot/garden/issues/58#issuecomment-6073808637
(2026-10-09): "Use `ci.minion.town` for deploys until the billing reset." This is option (b) from
heal job `heal-minion-town-39867df` (msg `msg-heal-minion-town-39867df-44e244494ac6`): the
production deploy role may run on the self-hosted `ci.minion.town` runner until the kriscendobot
Actions billing reset (~2026-10-30/31).

Context: `.github/workflows/deploy.yml` hard-codes `runs-on: ubuntu-latest`, so every main deploy
is refused (zero steps, no runner) during the block. #169 merged at 39867df but has not deployed,
and the proxy screener PAUSED the minion.town delegation at 2026-10-09 01:43Z because of it.
`test.yml` already switches via `vars.CI_RUNS_ON` (kriscendobot/minion.town#145); see
`skills/minion-town-ci-runner-switch/SKILL.md`.

Task:
1. Make deploy.yml's `runs-on` switchable the same way (e.g. a `DEPLOY_RUNS_ON` repo variable, or
   reuse `CI_RUNS_ON`; pick the simpler, reversible one and justify it in the PR), pointing at
   `["self-hosted","ci-minion-town"]` while the block lasts. Check the steps actually work on that
   runner (arm64 vs x64: the QEMU/emulator step and the node build; OIDC `id-token` to
   `minion-town-github-cd` works from self-hosted runners, but confirm the IAM trust policy's `sub`
   condition does not exclude it). Keep the change minimal and reversible.
2. Open the PR (draft, normal gauntlet). The maintainer's comment authorizes landing it; the
   delegation is paused, so the merge needs a conductor, not the proxy screen.
3. After merge, confirm the main deploy runs on `ci-minion-town` and succeeds (or
   `gh workflow run deploy.yml -R kriscendobot/minion.town`), so #169/39867df reaches production.
   A successful main deploy is what lets the screener resume the paused delegation; verify it did.
4. Update `skills/minion-town-ci-runner-switch/SKILL.md` (garden main2) § Notes "CD is separate"
   to describe the deploy switch and add the deploy flip to the switch-back-to-hosted procedure,
   so the scheduled return after the reset moves CD back too.
5. Reply on https://github.com/kriscendobot/garden/issues/58 with the outcome (do not close it).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-6073808637
submitter: kriskowal
----- END ISSUE NOTE -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T08:20:36Z
