**Viability check for kriscendobot/minion.town PR #94: proceed**

The PR is still needed and nothing has replaced it. I spent no budget on clean, panel, fix, CI-wait or un-draft.

PR facts: the PR is open, not merged and not a draft. Its title is "fix(security): authenticate the thunks' /token; stream deploy secrets past the box's /tmp". Head is `57d05a58`, base is the frozen `main-50aa690`, and the default branch is `main`.

Deciding question: Does current `main` still let anyone redeem a bare `code` at the GitHub OIDC thunk's `/token`, and do the deploy scripts still download secrets to fixed `/tmp` paths, with no other merged change fixing either one?
Answer: yes, on both counts.

Evidence:
- **`/token` on `main` (`deploy/aws/lambda/github-oidc-thunk/index.js`, around line 91):** it still reads a `code` from the request body or query and passes it straight to `openid.getTokens`. There is no `client_secret_basic` or `client_secret_post` check, and no `invalid_client` response.
- **Deploy scripts on `main`:**
  - `deploy-oauth2-proxy.sh:132-138` still downloads to `/tmp/oauth2-proxy.env` and writes `/tmp/op-client-secret`.
  - `deploy-billing-secrets.sh:112-124` still downloads to `/tmp/minion-billing.env` and `/tmp/caddy-billing.env`.
- **The 26 commits on `main` since the base `50aa690`** are PRs #169 (guest-recovery-key preflight), #175 (CD runner switch), #122 (Claude harness and Node tarball supply-chain hardening) and #176 (git-remote live validation). None of them touches thunk client authentication or how the deploy scripts handle secrets in `/tmp`.
- **Other PRs:** a search found no other PR on thunk `/token` authentication. #153 ("convert CD deploy scripts to JavaScript") overlaps the deploy-script area but is still open, so it hasn't replaced this one.
- **Review history:** the earlier panel rounds raised no objection to the premise. The packager and locksmith seats approved. The previous gauntlets ended in review-budget-reached (at `6098638b`) and halted (at `9afedef0`), and both still need maintainer action. The head has since moved to `57d05a58`.

Follow-ups:
- If this gauntlet runs, expect it to start from the newer head `57d05a58`, not `9afedef0`.
- The previous gauntlet halted with maintainer action still pending.
- Once #153 lands, this PR's changes to the deploy scripts will likely need a rebase onto it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-9afedef0-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (208807 cached reads)
- Output: 2256 tokens
- Cost: $0.4189934
- Wall-clock: 100s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
