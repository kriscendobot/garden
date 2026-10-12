**Fix round 1 for kriscendobot/minion.town PR #182: the fix is pushed and CI is green.**

I pushed commit `a5376f1` to `fix/prod-probe-ci-runs-on` as a follow-up on top of `17e4d3c`, using `safe-push-pr-head.sh`, which only allows an advancing push.

**Must-fix (raised by saboteur, breaker, wire-watcher and engine-realist).** The `report` job now runs on the self-hosted `ci-minion-town` runner. That host has curl and jq but not the `gh` CLI, so the `prod-probe-failure` tracking issue could never be opened or closed.
- I rewrote both `report` steps in `.github/workflows/prod-probe.yml` to call the GitHub REST API with `curl` and `jq` instead of `gh`. They create the label (an "already exists" error is ignored), find the open labelled issue while skipping PRs, then comment on it, create it, or close it with a comment. These steps now work on hosted and self-hosted runners alike.
- I didn't keep `report` on `ubuntu-latest`, because the PR exists to avoid hosted runners while hosted minutes are unavailable (#145).
- I didn't add `gh` to `bootstrap.sh`, because that only takes effect after someone re-runs it on the host.
- Shellcheck passes on both rewritten steps, and the "find the open issue" query returned without error against the live repo. The full report path has not run yet, since the PR isn't on `main`.

**Should-fix items, also done:**
- I added the #145 switch comment above the `probe` job's `runs-on` line, matching `deploy.yml`.
- In `DEPLOYMENT.md` § CI runner:
  - The intro now lists test, deploy and prod-probe as running on the self-hosted runner.
  - The trust note now names the production secrets that reach the host (the CD role through OIDC, and the `MINION_PROBE_CLIENT_CREDENTIALS_*` probe client). It explains that the `main`-only rules decide which branch gets a secret, not which machine sees it.
  - The trust note also says what to do after suspected tampering: treat the probe credential as exposed and check CloudTrail for the CD role. Replacing the credential is a manual job, because `deploy-cognito-probe-client.sh` never rotates it and a new client id also has to be added to `OAUTH_ALLOWED_CLIENT_IDS` and `config/policy.json`.
  - I replaced the out-of-date "deploy.yml still targets hosted runners" paragraph.

**CI:** `ci-wait-merge.sh --no-merge` returned 0. All three checks passed: test, Claude harness amd64 and Claude harness arm64.

**Follow-ups:**
- The breaker seat asked for a `workflow_dispatch` run showing the probe and report jobs working on the runner. That needs a `main` ref because of the `prod-probe` environment gate, so I didn't do it here; the first scheduled run after merge will be the proof.
- The breaker also noted that if the runner is down, the probe goes silent. That is unchanged and left for the maintainer's call.
- The panel-2 stage is next, posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1365249 cached reads)
- Output: 10686 tokens
- Cost: $1.0687538
- Wall-clock: 1938s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
