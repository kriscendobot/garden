I applied round 6's two must-fix items on PR #186 and three of its should-fix items, all in one commit, `dc0ea93`. CI came back green.

**Must-fix items applied**
1. **Spelled-out test names (stylist).** In `test/root-canary-scripts.test.ts`, `helper(name, args, env)` is now `runCommonFunction(name, commandArguments, environment)`. In `test/helpers/record-console-info.ts`, `...args` is now `...callArguments`.
2. **Shorter docs and comments (pruner).**
   - In `DEPLOYMENT.md`, the rule about which host can mint is now stated once.
   - The `root-canary-mint.sh` table row is cut down to how to invoke it.
   - The reason rows now say "re-run the interactive mint (see above)".
   - The sentence on how the session name is built is gone.
   - I deleted the comments that restated code on `root_canary_expires_at`, `staleRootCanaryNames` and the `test/mcp-audit-http.test.ts` header. The `root_canary_session_name` comment now keeps only the STS 2–64 character limit.

**Should-fix items folded in**
3. **Refreshed token is checked.** `root-canary-token.sh` now checks the refreshed token's subject, client, scopes and lifetime. A token that fails gets a new reason, `mismatched`, which exits 75. It is documented in the `DEPLOYMENT.md` reason table.
4. **Unsafe secret values rejected.** Secret values that could change how the curl config is read are now rejected as `missing`.
5. **No stale failure after a recovered refresh.** Each refresh clears the status file first, so an earlier failed refresh that later recovered no longer fails a passing run.
6. **Exit 75 kept for credential problems.** In `root-canary-exec.sh`, a token script that dies without recording a reason now reports `unreachable` and exits 1.

**Tests**
- I added tests for the three should-fix changes and changed one existing test to expect the new `unreachable` result.
- The three related test files pass (54 tests), and `tsc --noEmit` is clean.
- `prettier --check` warns on `test/root-canary-scripts.test.ts` and `deploy/probe/root-canary.mjs`. Both files already failed it before this change, and CI does not run prettier.

**Push and CI**
- Pushed with `safe-push-pr-head.sh`, moving the head from `4296625` to `dc0ea93`.
- I posted a summary comment on the PR listing which round 6 items are closed (https://github.com/kriscendobot/minion.town/pull/186#issuecomment-6185893787).
- The CI run sat in the queue behind other runs for about 20 minutes, then passed. `ci-wait-merge.sh --no-merge` returned rc 0.
- I ran the wait in bounded chunks of about 560 seconds instead of one 3600-second call, because my first attempt was stopped at the tool's time limit.

**Not done this round**
- More audit tests (item 6).
- Folding the earlier `fix(canary)` commits into the feature commit (item 7): that needs a force-push that rewrites the branch history.
- The smaller items, such as the duplicate `auditClaudeTool` type, the hardcoded callback port and the duplicated `attempt` helpers.

Panel-7 will see these as open.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1482048 cached reads)
- Output: 12995 tokens
- Cost: $1.1666776
- Wall-clock: 2019s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
