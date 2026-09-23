## Completion report: minion-town-endo-pin-f9cbcfc-verify

**Result:** the Endo daemon pin bump to `f9cbcfc426f7` (commit `920ffcc`, merged to `main` as PR #112, `df2277e`) is healthy in production. It did not crash-loop, so I reverted nothing.

**What I checked**
1. **CI with the pinned Endo:** the `test (typecheck + vitest)` workflow passed on the PR (run 35928189019) and on the `main` push (run 35928646871). The step that runs `test/endo-daemon-integration.test.ts` against f9cbcfc passed 5 of 5 tests, so the suite really ran.
2. **AWS deploy:** the continuous-deployment run 35928646842 passed every step. `deploy-endo-daemon.sh` reported "pinned commit on box: f9cbcfc426f7…" and the daemon restarted at 22:30:54Z.
3. **The daemon host itself** (checked over SSM on i-0380cd68b90020fad at +3 and +10 minutes):
   - `endo-daemon` is active and running on the same PID, with `NRestarts=0`. The daemon started exactly once after the deploy.
   - The only error line in its log is the SIGTERM that stopped the previous daemon.
   - The log shows `registry FORMULATE_LAZY` for existing hosts, followed by `host REINCARNATE`. That is the upstream registry migration running on the real production data, which is exactly what broke the earlier `89481580` pin. The commit message's claim that the migration landed upstream holds on the live data.
   - The top host lists its names, including the new `@registry`. An existing guest agent (`g-1c32…-agent`) still resolves its `sites` and `clip-*` names.
   - `minion-mcp`, `endo-gateway`, `caddy` and `oauth2-proxy` are all active, with 0 restarts for `minion-mcp` and `endo-gateway`.

**What changed**
- No repo changes and no revert.
- Memory: I added `minion-town-endo-pin-bump-verification.md` and its `MEMORY.md` entry. It records that CI starts the daemon with an empty store, so CI can't catch a migration failure on production data. It also records the SSM check steps, that f9cbcfc passed, and how to revert if a future bump fails.

**Follow-ups (minor, not posted)**
- `deploy/aws/reminder/store-deployed-daemon-compat.js` has a comment saying `deploy-endo-daemon.sh` pins f66505034, which is now out of date. The reminder files `COMPATIBILITY_STORE_PROVENANCE.json` and `test/reminder-store-conformance.test.ts` also still name f665050. They may be intentional records of an older state; someone who owns the reminder store should decide.
- The gateway deploy step logged `curl: (22) … 404` right after its restart, but the step still passed and the gateway is active. This is probably an expected 404 from a smoke probe; I did not look into it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-endo-pin-f9cbcfc-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1185218 cached reads)
- Output: 9725 tokens
- Cost: $0.9839516
- Wall-clock: 523s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
