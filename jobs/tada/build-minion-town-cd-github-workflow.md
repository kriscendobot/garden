The work is complete and verified. PR #4 is open, ready for review, actionlint-clean.

## Completion report

**Job:** Author a GitHub Actions continuous-deployment workflow for `kriscendobot/minion.town`.

**Delivered** — PR #4 (https://github.com/kriscendobot/minion.town/pull/4), branch `cd/github-actions-deploy`, ready for kriskowal's review (not draft, not ferried, no direct-push to `main`):

1. **`.github/workflows/deploy.yml`** — on push to `main` + `workflow_dispatch`, redeploys the steady-state stack in the dependency order `DEPLOYMENT.md` documents: `deploy-app.sh` → `deploy-oauth2-proxy.sh` → `deploy-caddy.sh` → `deploy-www.sh`. Each is its own step (a non-zero deploy fails loudly and names the layer). Idempotent, single-flight (`concurrency`, no cancel-in-progress), `[skip deploy]`/`[skip ci]` escape hatch, and a `deploy_target` choice for targeted single-layer redeploys.

2. **`deploy/aws/scripts/deploy-cd-iam.sh`** — the one human precondition, mirroring the repo's `common.sh` script style: idempotently provisions the GitHub OIDC provider + a **least-privilege** role `minion-town-github-cd`.

3. **`DEPLOYMENT.md § Continuous deployment`** — states pushes to `main` now auto-deploy, the auth model, the human precondition, and disable/override paths.

**The auth decision.** I confirmed the existing `github-oidc-thunk` is a *Cognito login IdP* (GitHub→Cognito user federation), **not** a GitHub-Actions→AWS trust path, so it didn't fit. Authored the minimal path instead: **GitHub OIDC → scoped IAM role** (`id-token: write` + `role-to-assume`, no long-lived keys). The role grants only what the four steady-state scripts touch — `ssm:SendCommand` on only `i-0380cd68b90020fad` + `AWS-RunShellScript`, S3 on only the artifacts bucket, and SecretsManager read on only `minion/web-gate-{client,cookie-secret}`; no `iam:*`/`lambda:*`/`cognito-idp:*`/`dynamodb:*`/`apigatewayv2:*`/create-secret/create-bucket. Trust is scoped to `repo:kriscendobot/minion.town:ref:refs/heads/main`. Provisioning scripts (Cognito, thunks, stores, the IAM-mutating `deploy-billing-store.sh`, secret-rendering `deploy-billing-secrets.sh`) are deliberately excluded from the auto path — which is what keeps the role least-privilege. Secret rendering preserves the presigned-S3 `0600` EnvironmentFile discipline; nothing echoes secret material to logs.

**Verification.** `actionlint` clean on the workflow; YAML parses; `bash -n` clean on the IAM script; both generated IAM policy JSON documents validated with `python -m json.tool`; permissions/trust blocks reviewed for coherence.

**Human precondition (flagged in the PR, blocks a live run):** a maintainer must run `deploy/aws/scripts/deploy-cd-iam.sh` once (garden-fleet admin creds) before the first deploy; until then a run fails at "Configure AWS credentials" by design. I did not attempt a live deploy.

**Follow-ups:** (1) apply `deploy-cd-iam.sh` before enabling; (2) if billing env or infra inputs change, run the excluded provisioning scripts by hand (documented); (3) optional future hardening — a CloudWatch alarm on deploy failures / pool MAU is out of scope here.

No garden-side (`main2`) changes were needed — all work landed in the project repo.
