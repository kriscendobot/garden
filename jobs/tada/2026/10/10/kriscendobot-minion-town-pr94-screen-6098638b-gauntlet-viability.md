Verdict: proceed. PR #94 is still needed — it hasn't been superseded and current `main` still has the problems it fixes.

**Viability gate: kriscendobot/minion.town PR #94**, "fix(security): authenticate the thunk token endpoints; keep deploy secrets out of /tmp"

What I did: I read the PR's facts, description, files, reviews and comments. I compared its frozen base `main-50aa690` with the current `main` (20 commits ahead, 0 behind). I grepped the files the PR touches on `main` for the vulnerable patterns. I also checked the open PRs that touch the same deploy scripts. I changed no code, ran no gauntlet steps, and made no commits.

**PR state:** OPEN, not merged, not draft, MERGEABLE. Head is `6098638b`.

**Deciding question:** Does current `kriscendobot/minion.town` `main` still have all three weaknesses PR #94 fixes, with no merged PR or newer design already fixing them?
1. The GitHub OIDC thunk's `/token` redeems a code without client authentication.
2. The SIWE thunk looks up clients through the prototype chain (`in`) and compares secrets in non-constant time.
3. The deploy scripts write secrets to fixed `/tmp` paths.

Answer: yes.

**Evidence:**
- **GitHub thunk:** on `main`, `deploy/aws/lambda/github-oidc-thunk/index.js:91-98` still goes straight from `body.code` to `openid.getTokens(code, …)` with no client-credential check.
- **SIWE thunk:** on `main`, `deploy/thunks/siwe/src/openid.js:87` and `:162` still use `clientId in clients`, and line 162 compares the secret with plain `!==`.
- **Deploy scripts:** on `main`, `deploy/aws/scripts/deploy-billing-secrets.sh:112-125` still downloads secrets to `/tmp/minion-billing.env` and `/tmp/caddy-billing.env`.
- **Newer history:** the 20 commits on `main` since the base are about the guest-recovery-key preflight (#169), switching the CD runner (#175), and the Claude/Node supply-chain pins (#122). None of them touches the thunks or the `/tmp` secret handling. The only file both sides touch is `deploy-account-endpoint-secret.sh`, which is an ordinary rebase or weave concern, not a sign the fix was replaced.
- **Overlapping PRs:** #152 (draft), #153 and #154 (draft) convert the deploy shell scripts to JavaScript. All three are open and unmerged, and they don't touch the thunk `/token` code. They may conflict with the shell-script part of #94 later, but they haven't displaced it.
- **Discussion:** every review and comment is from the bot's own panel and gauntlet rounds. Nothing from the maintainer closes, rejects or redirects the PR. Its motivation, findings from the 2026-09-04 security review, still applies.

**Context for the maintainer:** two earlier gauntlets on this PR (screen `e8518a2f` and screen `269fdc5d`) both stopped at `review-budget-reached` after 6 rounds, with the panel still repeating must-fix findings on `secretsEqual`, `index.js` and `openid.js`. That doesn't decide viability, but another loop may hit the same limit unless the remaining findings are settled or the PR is split.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (310433 cached reads)
- Output: 3115 tokens
- Cost: $0.5613066
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
