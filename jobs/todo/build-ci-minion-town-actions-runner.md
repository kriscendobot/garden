---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** Autonomously deploy and validate a **self-hosted GitHub Actions runner at `ci.minion.town` on AWS**, then prove it runs real CI end to end.

Maintainer ask (kriskowal, liaison session 2026-09-30): "Please post a job to autonomously deploy and validate a Github CI action runner at `ci.minion.town` on AWS."

**Context:**
- On 2026-09-30 the kriscendobot account hit an **account-wide GitHub Actions billing block**. Hosted jobs never start ("recent account payments have failed or your spending limit needs to be increased"), so every repo the account owns goes red together. See the shepherd field note in `roles/shepherd/AGENT.md` (commit f3413cdb) and https://github.com/kriscendobot/minion.town/pull/144.
- A self-hosted runner does not consume hosted-runner minutes.
- The minion.town AWS footprint (account, SSM access from endolin hosts with the `garden-fleet` creds, Route 53 / DNS for minion.town, existing EC2 hosts) is described in the minion.town repo's deploy docs (`deploy/aws/`, DEPLOYMENT.md). Read those first and reuse the established patterns: IaC/scripts under `deploy/aws/`, SSM rather than SSH, and no secrets in git.

**Deliverables:**
1. **Infrastructure:**
   - a dedicated EC2 instance, or an autoscaled ephemeral runner group if the existing IaC style makes that simple;
   - `ci.minion.town` DNS;
   - its own IAM role with least privilege.
   - It must be **isolated from production minion.town**: no prod instance role, no prod secrets, no network path to prod-only services beyond what CI needs.
   - Size it for the repos' real builds (Node/yarn/npm, plus Rust for endo-but-for-bots if in scope) and keep the monthly cost modest. State the cost in the report.
2. **Runner registration:**
   - Register it with GitHub (org- or repo-level as appropriate) with a clear label such as `ci-minion-town`.
   - Run it as a systemd service with auto-restart.
   - Prefer **ephemeral / just-in-time runners** (a fresh job environment each run) so one job cannot poison the next.
   - Keep the registration token/PAT or GitHub App credentials in AWS Secrets Manager or SSM Parameter Store, never in the repo or journal.
3. **Security (non-negotiable; surface anything you cannot meet instead of weakening it):**
   - **Never attach the self-hosted runner to a public repository** where fork PRs can run arbitrary code on it. kriscendobot/minion.town is private and in scope.
   - For any other repo, check its visibility first. Only register it if it is private, or if fork-PR workflows provably cannot target the runner. Otherwise list it in the report as needing a maintainer decision.
   - Harden the host: unattended security updates, no inbound SSH (SSM only), minimal inbound ports (a runner needs **outbound-only** access to GitHub; `ci.minion.town` may not need to serve anything). If it serves a status page or webhook, put it behind TLS.
4. **Workflow wiring:** add `runs-on` targeting for the runner label in the target repo(s). Put this in a PR through the normal garden flow (draft PR; the maintainer runs the gauntlet), and do not push to main. Keep hosted runners as a fallback only if that is simple.
5. **Validation (prove it, don't assert it):**
   - A real CI run of kriscendobot/minion.town completes green on the self-hosted runner. Show the runner name in the job log.
   - A deliberately failing job shows up red, which proves the results are real.
   - A reboot or service restart re-registers the runner.
   - An ephemeral job leaves no residue for the next job.
   - Record links to the runs.
6. **Operations doc:** add a short `DEPLOYMENT.md` / `deploy/aws/` section in minion.town, plus a garden `context/operations/` note on how to check, restart, rotate the registration credential, scale and tear down the runner.

**Surface to the maintainer rather than deciding alone:**
- cost above roughly $50/month;
- adding any public repo;
- widening IAM beyond least privilege;
- anything that touches production minion.town hosts or DNS records other than `ci.minion.town`.

Use the maintainer's 90% quota policy if the work is long. Land garden-side docs direct to `main2`.
