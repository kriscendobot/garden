Builder job — author a GitHub Actions **continuous-deployment** workflow for `kriscendobot/minion.town`.

**Goal.** On push to `main` (and via manual `workflow_dispatch`), redeploy the live minion.town stack automatically, so a merge like PR #3 deploys without a hand-run of the `deploy-*.sh` scripts.

**What the live deployment actually is** (do not reinvent it — wrap it):
- Target: **EC2 instance `i-0380cd68b90020fad`** + Caddy + Cognito, region **us-west-1**. Deployed by the repo's `deploy-*.sh` scripts (e.g. `deploy-billing-store.sh`, `deploy-billing-secrets.sh`, and the app/oauth2-proxy/caddy/www steps) in the order documented in `DEPLOYMENT.md`. Read `DEPLOYMENT.md` first — it is the source of truth for the deploy sequence and the secrets involved.
- Secrets are rendered to `0600` EnvironmentFiles via presigned-S3, never through SSM text; Stripe is in **TEST mode**. The workflow must preserve those properties and never echo secret material into build logs.

**The one real design decision — GitHub Actions → AWS auth.** Prefer **GitHub OIDC → a scoped AWS IAM role** (`aws-actions/configure-aws-credentials` with `role-to-assume`, `id-token: write`) over long-lived access keys. A "GitHub OIDC thunk" already exists in the minion.town phase work — reuse/extend that trust path if it fits; otherwise author the minimal IAM role + OIDC provider trust and document what a maintainer must apply. The role must be **least-privilege**: only what the deploy path needs (SSM send-command / S3 presign / the specific resources the `deploy-*.sh` scripts touch), no broader.

**Shape.** Trigger the existing deploy scripts against the running instance (the scripts already use SSM/IMDS, so driving them via `aws ssm send-command` or an SSH-less SSM session is the natural fit — match whatever `DEPLOYMENT.md` already does). Keep the workflow idempotent and re-runnable; fail loudly on a non-zero deploy step.

**Deliverable.** A `.github/workflows/deploy.yml` (name it sensibly) on a branch, plus any IAM/OIDC trust doc a maintainer must apply, opened as a PR against `kriscendobot/minion.town` for kriskowal's review. Do **not** direct-push to `main` and do **not** ferry upstream. Update `DEPLOYMENT.md` to note that pushes to `main` now auto-deploy via the workflow, and how to disable/override it.

**Verify before handoff.** Validate the workflow YAML (actionlint or equivalent) and confirm the auth/permissions blocks are coherent. A live end-to-end deploy from Actions needs the maintainer to apply the IAM/OIDC trust first, so flag that as the human precondition in the PR description rather than attempting a live run without it.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  claimed_at: 2026-07-10T06:03:38Z
