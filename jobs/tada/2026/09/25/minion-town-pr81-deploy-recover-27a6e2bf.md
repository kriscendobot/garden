---
handed-off: minion-town-pr81-verify-live-after-pr118
deliverable-complete: false
---
# Job minion-town-pr81-deploy-recover-27a6e2bf: handed off, #81 not yet live

The #81 code is **not yet in production**. It is waiting on a merge directive for the fix PR, kriscendobot/minion.town#118 (CI green). Production is healthy on the restored `df2277e` artifact. A parked successor job owns the remaining work.

## Production health
Checked over SSM: `minion-mcp` is active with NRestarts=0, loopback `/healthz` returns 200, and the deployment receipt shows `df2277e` promoted. The failed #81 tree is kept at `/opt/minion-town.failed` with a "rolled-back" receipt.

## Why the deploy failed (two real defects, not a slow start)
1. **Run 36098733289:** the #81 app crashed on start with `DynamoDB guest recovery requires a recovery key of at least 32 characters`. #81 made `GUEST_RECOVERY_KEY` mandatory, but it is delivered by scripts an operator has to run, and CD doesn't run them. They had never been run on prod.
   - **Fixed operationally:** I ran the committed `deploy-accounts-store.sh` and `deploy-account-endpoint-secret.sh` from this host as `garden-fleet`.
     - The first extends the app role's policy to allow `UpdateItem` on the recovery attributes only.
     - The second created the Secrets Manager secrets `minion/guest-recovery-key` and `minion/account-endpoint-token`, and wrote `/etc/minion-mcp/account.env` plus the Caddy drop-in.
   - **Side effect:** this armed the `/account` gate for the first time. A request without the token now gets 403, and I confirmed the running Caddy config carries the token.
2. **Re-run 36099720190:** the app came up, but the loopback `/healthz` smoke returned **400** and the deploy rolled back again.
   - Cause: `makeGuestWebRouter` is mounted at the app root, and its HTTPS/no-store middleware ran for every later route. So `/healthz` over plain HTTP was rejected in production.

## Fix PR: kriscendobot/minion.town#118 (draft, CI green on test and both harness jobs)
- Limits the router middleware to `/api/guest` and `/account/guest-recovery`.
- Adds a regression test. It fails without the fix and passes with it; typecheck is clean.
- Makes `deploy-app.sh` print the last 40 lines of the `minion-mcp` journal when the smoke fails, so the cause shows in the CI log.
- Base is a new frozen branch, `main-27a6e2b`, as `ensure-pr.sh` requires; its content is identical to `main`.
- I did **not** merge it. There is no maintainer directive, and the 2026-09-23 conduct authority covers only pin advancements.

## Communication
- Posted a status comment on #81 explaining the delay and the gate arming: https://github.com/kriscendobot/minion.town/pull/81#issuecomment-5827540076
- Messaged the maintainer asking for a "merge 118" go-ahead. No reply came in about 35 minutes of polling.

## Successor
`minion-town-pr81-verify-live-after-pr118` is parked, blocked on #118, so it is promoted automatically when #118 merges. It will:
- confirm or re-dispatch the CD deploy;
- check over SSM that the app is active and the receipt shows promoted;
- probe the public guest route and `/healthz`;
- comment "deployed, ready for evaluation" on #81.

Its public probe (`POST /api/guest`) creates one real guest in production.

## Follow-ups
- #118 needs a merge directive, or a "merge 118" through the liaison.
- The underlying problem remains: a secret the app needs at startup is provisioned only by a hand-run script, and CD neither runs nor checks for it. A pre-restart check in `deploy-app.sh` would catch this; that is the maintainer's call.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr81-deploy-recover-27a6e2bf.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3417677 cached reads)
- Output: 21140 tokens
- Cost: $1.8905754
- Wall-clock: 2998s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
