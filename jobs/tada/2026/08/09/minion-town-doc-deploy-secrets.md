Empty inbox. Job complete.

## Completion report

**Job:** Document the maintainer-facing credential/secret setup for continuous deployment (follow-up to the approved review on kriscendobot/minion.town PR #18).

**Ground truth verified against the tree (not assumed):**
- Audited `.github/workflows/` — **zero** `${{ secrets.* }}` / `${{ vars.* }}`. CD authenticates purely via GitHub OIDC → the scoped IAM role `minion-town-github-cd` (`AWS_DEPLOY_ROLE_ARN`, committed in the workflow `env:`).
- Read every `deploy/aws/scripts/*.sh` that touches Secrets Manager to get exact secret ids, JSON shapes, and which script creates each — distinguishing maintainer-provided (`minion/web-gate-client`, `minion/github-oauth-app`, `minion/stripe`; scripts `die` if absent) from deploy-generated (gate tokens, cookie secret, signing keys, siwe creds, `eth-rpc-url`). Confirmed `eth-rpc-url` is a **raw URL string**, not JSON, and corrected a first draft that had it wrong.

**What changed** (one file, `DEPLOYMENT.md`, +76/−5):
- New `### First-run credential & secret checklist (maintainer setup)` under § Continuous deployment: (1) explicit "there are NO GitHub Actions secrets/variables" statement so a maintainer isn't hunting for secrets that don't exist; (2) OIDC bootstrap via `deploy-cd-iam.mjs` as the single first-run precondition; (3) two Secrets Manager tables (maintainer-provided vs deploy-generated) with shapes, consuming scripts, and which two the CD role actually reads; (4) an example `aws secretsmanager create-secret` command.
- Staleness fix: added `deploy-endo-gateway.sh` to the documented CD run-order and the `deploy_target` option list (the workflow runs it; the doc had drifted).

**Delivered as:** branch `docs/deploy-secrets-maintainer-checklist` → **PR kriscendobot/minion.town#29** (documentation only; does not block #18's merge, as the job specified). No AWS/GitHub account mutation was performed — correct per identity discipline; the resolution is the runbook, and setting the actual secrets remains the maintainer's step.

**Follow-ups:** none required. The maintainer can now follow the checklist to arm the OIDC role and create the three maintainer-provided secrets before the first Actions-triggered deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-doc-deploy-secrets.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1210697 cached reads)
- Output: 14311 tokens
- Cost: $1.6239394999999999
- Wall-clock: 223s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
