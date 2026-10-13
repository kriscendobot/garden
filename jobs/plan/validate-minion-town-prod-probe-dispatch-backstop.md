---
gate: awaiting-maintainer
maintainer_question: 'Seed the repository-scoped Actions read/write PAT in AWS secret minion/prod-probe-dispatch-token, then promote this validation job.'
asked_at: https://github.com/kriscendobot/minion.town/pull/184
priority: high
role: builder
arc: minion-town
posted_by: gardener
posted_at: 2026-10-13T00:20:52Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Validate and finish the minion.town production-probe dispatch backstop

Repo: kriscendobot/minion.town. Continue draft PR https://github.com/kriscendobot/minion.town/pull/184 from branch `fix/prod-probe-dispatch-backstop`; do not open another PR.

The implementation is committed at `935b6d6` and the main test workflow passed. The only unfinished acceptance criterion is production validation, which requires a maintainer-created fine-grained PAT scoped only to `kriscendobot/minion.town` with Actions: read and write. The maintainer was asked to seed it in AWS Secrets Manager us-west-1 as JSON `{"token":"..."}` under `minion/prod-probe-dispatch-token`; never request or use a maintainer credential or the broader bot OAuth token.

When the secret exists:

1. Reconcile the runner Lambda IAM/config/code from the PR branch (the checked-in provisioner is authoritative; a targeted boto3 update is acceptable if this headless environment still lacks the AWS CLI).
2. Install and enable the checked-in `prod-probe-backstop` service and timer on the `minion-town-ci` instance through SSM.
3. Through SSM, run `/usr/local/sbin/prod-probe-backstop --force --ref fix/prod-probe-dispatch-backstop` to simulate a stale gap. Confirm the Lambda reports `action=dispatched`, a new `prod-probe.yml` workflow_dispatch run is created for this ref, and the run carries strict behavior. The branch may be denied the main-only production environment; the required observation is that the deployed backstop creates the run. Do not weaken the environment gate.
4. Confirm the installed timer is active and an ordinary no-option invocation reports fresh while targeting `main` by default. Record run URL and systemd evidence in the completion report and, if useful, the PR body.
5. If validation exposes a defect, fix it on the same branch, rerun all relevant tests and pre-push gates, and push. Complete as the builder naming PR #184 so its gauntlet stages normally.

Local evidence already obtained: pre-push gates and typecheck passed; `node --test deploy/aws/ci-runner/lambda/test/index.test.mjs` passed 21/21; CI `test` passed. The repository-wide local Vitest suite had 21 environment-only failures in existing Caddy/sudo tests, while the GitHub `test` check passed.
