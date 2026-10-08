**Viability: proceed.** PR #94 is still needed and nothing has replaced it.

**PR facts:** kriscendobot/minion.town#94 is OPEN, not merged and not a draft. Its base is `main-50aa690`, which is the same commit as the current `main` tip (`50aa690f87b`). The head `269fdc5dd4f` is 7 commits ahead of `main` and 0 behind. GitHub reports it as MERGEABLE.

**Deciding question:** Does the current base still lack all three hardening fixes from PR #94, with no other merged or open PR making them unnecessary? Those fixes are: GitHub OIDC thunk `/token` requires client authentication; the SIWE thunk uses own-property client lookup and a constant-time secret check; deploy scripts stop staging secrets in `/tmp`.

**Evidence:**
- **`/token` fix not on `main`:** On `main`, `deploy/aws/lambda/github-oidc-thunk/index.js` still accepts a bare `code` at `/token` with no client authentication. It contains no `client_secret` or `timingSafe` reference.
- **SIWE fix not on `main`:** On `main`, `deploy/thunks/siwe/src/openid.js` has no own-property lookup (`hasOwn`) and no constant-time compare.
- **Deploy-script fix not on `main`:** On `main`, all three scripts (`deploy-billing-secrets.sh`, `deploy-account-endpoint-secret.sh`, `deploy-oauth2-proxy.sh`) still download files to fixed `/tmp/...` paths on the box, e.g. `curl ... -o /tmp/minion-billing.env`. The PR replaces this by streaming each file straight into a 0600 destination.
- **Base and `main` are the same commit:** comparing `main-50aa690...main` shows 0 commits ahead, so nothing newer has landed in these files.
- **No PR supersedes it:** Searching all PRs turned up nothing merged or open that replaces these fixes. #152 and #154 (open) convert the deploy scripts to JavaScript. They could conflict textually with the shell-script part later, but they do not replace the `/token` or SIWE fixes.
- **Recent reviews still treat it as live work:** The latest review (2026-10-08) raised only two description notes (both marked `summary-fix`) and a coverage-report gap. None of them says the PR is obsolete.

Nothing was changed: no commits, pushes or posted jobs.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-269fdc5d-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (232213 cached reads)
- Output: 2443 tokens
- Cost: $0.46856660000000006
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
