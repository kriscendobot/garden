**PR #169 (kriscendobot/minion.town): the gauntlet can go ahead.**

- **PR state:** open draft, not merged, no reviews or comments yet. Opened 2026-10-07 by job `build-minion-town-deploy-secret-preflight`. Head is `c37488c7576e`. The base `main-d750b09` is pinned to the current tip of `main` (d750b09, which merged #165), and `main` has made no commits since that pin.
- **Deciding question:** Does current `main` still start the app with a required `GUEST_RECOVERY_KEY` that only the hand-run provisioning script delivers, with no automated continuous-deployment (CD) render and no preflight check, and has nothing else replaced this fix?
- **Evidence:**
  - **The key is required at startup.** On `main`, `src/http.ts:611-613` builds the DynamoDB account store with `config.guestRecoveryKey`. The config value comes from `process.env.GUEST_RECOVERY_KEY ?? ""` (`src/config.ts:262`). `src/auth/stores/dynamodb.ts:54-55` throws if that key is shorter than 32 characters, so a host without the key crash-loops.
  - **Only the manual script provides the key.** `deploy/aws/scripts/deploy-account-endpoint-secret.sh` is a provisioning script someone has to run by hand. It renders the key into `/etc/minion-mcp/account.env`. The systemd unit loads that file as optional (`EnvironmentFile=-…`, `minion-mcp.service:108`), so a missing file doesn't stop the service from launching.
  - **CD doesn't touch the key.** On `main`, `.github/workflows/deploy.yml` never mentions the recovery key, and no preflight script exists.
  - **No other PR replaces this one.** A search for PRs about the guest-recovery key turned up only #169 with this purpose. Nearby PRs (#129, #131, #133, #168, #114) cover guest-shell recovery behaviour, adding Sign-In with Ethereum (SIWE) as a recovery provider, and OAuth bond design, not deploy secrets.

The PR's motivation, that a fresh host or a rotated secret turns an ordinary deploy into a crash loop, still holds on current `main`, and nothing has superseded it.

No garden changes, commits or follow-ups came out of this stage.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (329540 cached reads)
- Output: 2477 tokens
- Cost: $0.46521599999999996
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
