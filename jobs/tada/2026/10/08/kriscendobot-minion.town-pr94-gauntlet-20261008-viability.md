I checked PR #94 against current `main`. It hasn't been superseded and the gaps it fixes are still there, so **viability=proceed**. I spent no clean, panel, fix or CI budget and changed nothing in any repo.

**Deciding question:** Does current `kriscendobot/minion.town` `main` still lack all three of #94's fixes, with nothing merged that replaces them?

**Answer: yes.**

**Evidence:**
- **PR state:** open, not merged and not a draft. The head is `51314780b3`, on a frozen base branch `main-d750b09`. Compared with `main` the head is 1 commit ahead and 0 behind, touching the 5 files it claims. There are no reviews or comments yet.
- **GitHub OIDC thunk (High):** on `main`, the `/token` route in `deploy/aws/lambda/github-oidc-thunk/index.js` still passes a bare `code` to `openid.getTokens()` without checking the caller's credentials. The only commit that ever touched the file is the original `868eb2ad3` (2026-07-07). The thunk tree is still on `main` and is still the live GitHub identity route for Cognito, so the problem is still real.
- **SIWE thunk (Medium):** `deploy/thunks/siwe/src/openid.js` on `main` still checks the secret with `!(clientId in clients) || clients[clientId] !== …`. That is a plain `!==` compare and an `in` lookup that also searches inherited properties. There is no `timingSafeEqual` anywhere in the file.
- **Deploy scripts (Medium):**
  - In `deploy-account-endpoint-secret.sh` and `deploy-billing-secrets.sh`, `umask 077` sets permissions only on the operator's machine. The script these send to the server still downloads secret env files into `/tmp` with no umask, so they are world-readable for a moment. Both also still use `sudo mkdir -p`.
  - In `deploy-oauth2-proxy.sh`, the umask still comes *after* the raw `oauth2-proxy.env` download.
- **Competing work:** a search found no other PR that fixes these. Draft PR #152 (converting the deploy scripts to JavaScript, last updated 2026-10-04) touches the account-endpoint and billing scripts. It is an unmerged draft, so it doesn't replace #94. Whichever one merges second will need a rebase.

No follow-up jobs were posted. The heads-up: once the gauntlet un-drafts #94, the thunk and SIWE changes only take effect when an operator re-runs `deploy-thunk.sh` and `deploy-siwe-thunk.sh` after merge.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr94-gauntlet-20261008-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (277463 cached reads)
- Output: 2824 tokens
- Cost: $0.47207659999999996
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
