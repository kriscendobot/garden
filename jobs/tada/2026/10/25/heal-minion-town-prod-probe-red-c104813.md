The prod probe passes all checks again. The failures came from the daemon restart during the deploy, not from #218's code. Prod is fixed by restarting two services by hand. The permanent fix is in draft PR #224, which still has to merge.

**What broke.** Deploy run 40135158359 restarted the Endo daemon in step 8 at 21:40:50. The pin was still `1706e63247fb`. Step 9, the app deploy, then failed #218's preflight ("no guest bond ledger provisioning marker"), so steps 9–17 were skipped. The app (`minion-mcp`) and the clip gateway (`endo-gateway`) normally get restarted by those later steps. They hold live connections to the daemon (CapTP) and don't reconnect when it restarts. The logs on the box show both connections dropping (`Connection stream ended`) at 21:40:50, and the gateway logging `bootstrap lookup failed …` on every probe after that. So:
- `GET /api/guest` answered 401 because the app's connection to the daemon was dead.
- `/.well-known/ocapn-bootstrap` answered 404 because the gateway's connection was dead.

The probe's guest credential, the canary clip, the daemon pin and the routes were all unchanged. No re-seed was needed, and no design question came up.

**Production fix.** At 2026-10-25T00:55Z I ran `systemctl restart minion-mcp endo-gateway` on `i-0380cd68b90020fad` through AWS SSM. This kept the deployed app, which predates #218; `/opt/minion-town` is unchanged and the staged #218 app was never promoted. A manual run of the prod probe passed all 8 checks: https://github.com/kriscendobot/minion.town/actions/runs/40148635793

**Forward fix: https://github.com/kriscendobot/minion.town/pull/224** (draft, based on the snapshot branch `main-c104813`).
- **`deploy/aws/scripts/deploy-endo-daemon.sh`:** after the daemon comes up healthy, and after its own built-in rollback, it now restarts `minion-mcp` and `endo-gateway` if they're running (`systemctl try-restart`).
- **`deploy/aws/scripts/rollback-endo-daemon.sh tree`:** same restart.
- **Same bug, other paths:** a daemon-only deploy (`deploy_target: endo-daemon`) and a manual rollback also left both services stuck. This fixes those too.
- **Checks:** a shell syntax check passed on both the outer script and the script it sends to the box. The 4 existing test files that cover the deploy script passed (79 tests).
- **Not tested on a live deploy yet.**

**About #222:** reverting #218's code does nothing about the cause. But a *successful* full deploy of #222 would restart the app and gateway as a side effect, so it would have cleared these two checks by accident. Until #224 merges, any deploy whose app step fails will break production the same way again. I also left a note to the #222 job, but that job had already finished, so the message was dead-lettered and will be turned into a new job.

**Follow-ups:**
- #224 needs its review and merge in order with #222. Merging is paused for the #218 heal, and I did not resume it.
- Unrelated, seen on the box: `endo-gateway-gc.service` and `endo-revival-dry-run-20260916.service` are in a failed state.
- Longer term, the two services could reconnect to the daemon on their own instead of relying on deploy-time restarts.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/heal-minion-town-prod-probe-red-c104813.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1617825 cached reads)
- Output: 11095 tokens
- Cost: $1.1604010000000002
- Wall-clock: 309s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
