---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# minion.town: stop the Claude-harness image builds from starving the single CI runner

Repo: kriscendobot/minion.town (supervised carry under the 2026-10-07 standing order;
workflow changes are authorized, no maintainer escalation). Posted by the minion.town arc
supervisor (job minion-town-arc-press-20261017-180508), tracker kriscendobot/garden#58.

## Evidence (2026-10-17 ~20:40Z)
- `.github/workflows/test.yml` runs the `claude-harness-images` matrix (amd64 + arm64,
  up to 20 min each) on EVERY push/PR, with no path gate. The repo has ONE ephemeral
  self-hosted runner (`ci-minion-town`) that serializes jobs, and hosted minutes are
  billing-blocked until ~2026-10-30.
- Result: ~20 jobs queued, PR CI latency over 3 hours. Docs-only PR #203 still queues two
  harness builds. The prod probe's `report` job (run 39045639323) has been queued since
  16:20Z. Because the `minion-town-prod-probe` concurrency group is held, later
  probe runs are cancelled or left pending, so production validation of the issue-58
  objectives lags with them.

## Ask
1. Gate the Claude-harness image jobs so they run only when a harness-relevant path
   changes (the harness pin/verifier, its Dockerfile/build inputs, the workflow itself)
   and on pushes to `main`. Use a job-level condition (for example a cheap `changes` job
   with a paths filter) so the jobs report *skipped*, not missing, and any required
   status check stays satisfied. Confirm against the branch protection on `main` before
   choosing the mechanism.
2. If it's cheap and safe, apply the same treatment to the browser gate (webkit/firefox/chromium) for PRs
   that touch no shell/clip code.
3. Optional and at your judgment: keep the prod-probe `report` job from waiting behind
   PR builds (for example by moving its issue write into the `probe` job). Don't
   enable hosted runners, and don't add AWS instances without a cost note in the PR.

Open the PR through ensure-pr.sh as a DRAFT; the gauntlet and the proxy screen carry it.
Done when the PR is open and green, and a docs-only PR run shows the harness jobs skipped.

<!-- garden-reaped: 0 -->

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-18T00:24:10Z
