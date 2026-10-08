**Panel round 1 on kriscendobot/minion.town PR #94 (screen gauntlet `e8518a2f`): must-fix**

**Run:**
- I made an isolated checkout of the PR head (`kriscendobot/minion.town@security/token-client-auth-and-secret-umask`, head `e8518a2f`).
- I ran `panel.sh` in single-round mode with `GARDEN_YARN=npm`, launched detached and polled until it finished.
- I passed the PR's `baseRefOid` `d750b09b` as the base. The files it compared match GitHub's file list for the PR (9 files).
- `panel.sh` exited 0 with `code-panel single-round — must-fix`. The 34 seats split 1 request-changes, 19 comment-only and 14 approve.
- The record is at journal `panel-runs/kriscendobot-minion.town-94/4310f5ebd94f.md`.
- The pre-pass flagged that the two prior rounds kept raising must-fix findings on the same mechanisms: `secretsEqual`, `/token` and `umask 077`. So the decomplector was asked whether these are needed at all.

**Blocking finding (decomplector):**
- Remove the `umask 077` + `mktemp -d` + `trap` + `rm` secret staging from `deploy-account-endpoint-secret.sh`, `deploy-billing-secrets.sh` and `deploy-oauth2-proxy.sh`.
- Use the existing `curl … | sudo install -m 0600 /dev/stdin <dest>.new && mv` pattern from `deploy-npm-registry-secret.sh:132-137` instead.
- The decomplector judged `secretsEqual` and the `/token` client-auth gate to be needed.

**Non-blocking (should-fix):**
- The two Basic parsers still differ on whether the scheme is case-sensitive.
- RFC 6749 issues: § 2.3.1 form-urlencoding, the missing `WWW-Authenticate` header on 401s (§ 5.2), and accepting two auth methods in one request (§ 2.3).
- `secretsEqual` is duplicated across the two thunks.
- The Secrets Manager failure path logs nothing and runs before the cheap rejection.
- The prototype-chain test doesn't really test anything.
- Rollout ordering for RP callers.
- The fixup commits should be squashed before merge.

**Posted:**
- The review is at https://github.com/kriscendobot/minion.town/pull/94#pullrequestreview-5453733104. It is headed `<!-- garden-panel-verdict -->` with `disposition: must-fix` and holds the request-changes and comment-only seat blocks (64,004 characters, under GitHub's limit).
- It posted as COMMENTED, not request-changes, because GitHub won't let the bot request changes on its own PR.
- The approving seats' blocks went in a companion comment: https://github.com/kriscendobot/minion.town/pull/94#issuecomment-6055773808

I made no fixes and didn't un-draft; the gauntlet's fix stage takes it from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-e8518a2f-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1292224 cached reads)
- Output: 8317 tokens
- Cost: $1.0006328000000002
- Wall-clock: 273s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
