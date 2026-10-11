# Fix round 4 for kriscendobot/minion.town PR #166: done, CI green

I applied all four must-fix items from the panel-4 review, pushed them as one follow-up commit (`e092028`, advanced from `e5f7548` with `safe-push-pr-head.sh`), and CI passed. I did not re-run the panel.

**What changed:**

1. **Probe no longer imports gateway source (decomplector).**
   - `deploy/probe/prod-objectives.mjs` now holds the expected headers as literals, exported as `EXPECTED_ISOLATION_HEADERS` and `EXPECTED_IMMUTABLE_CACHE`. It no longer imports `.ts` files.
   - A new offline vitest, `test/prod-probe-expectations.test.ts`, checks that those literals equal the gateway's `ISOLATION_HEADERS` and `IMMUTABLE_CACHE`. `test.yml` runs it through `npm test`.
   - `prod-objectives.test.mjs` now uses the probe's own exports instead of the gateway's `.ts` files.
   - I removed `src/endo/gateway/cache-policy.ts`. `content-server.ts` is back to the base version, except that it now exports `IMMUTABLE_CACHE`.
   - The `engines` setting in `package.json` and `package-lock.json` is back to `>=22.15.0`, and I restored the base text of DEPLOYMENT.md § Node floor.
2. **PR body (pruner).** I removed the "Other changes" walk through individual files, the Node-floor bullet and the cache-policy bullet. The evidence section now links the green CI run instead of quoting "16/16".
3. **Duplicated prose (pruner).**
   - The probe client's three-tool limit is now stated in one place: the `tools` array in its `config/policy.json` entry. The DEPLOYMENT table row and the header of `deploy-cognito-probe-client.sh` point there.
   - I cut the policy note sentence that repeated the `tools` array.
   - The DEPLOYMENT "Canary clip" paragraph is now a pointer to the `note` in `canary.json`, and the "Credential" paragraph is a pointer to the mint script plus the local-run snippet.
4. **The `tools` axis is now described where authorization is (integrator).** The top-level note in `config/policy.json` and DEPLOYMENT.md § Resolution algebra now say that a per-identity `tools` list only narrows, and that it applies after scopes and the guest facet.

**Verification:**
- Locally: the probe's 16 node tests pass, the related vitest suites pass (156 tests, including the new drift test), and `npm run typecheck` is clean.
- CI: `test (typecheck + vitest)` passed on `e092028` (https://github.com/kriscendobot/minion.town/actions/runs/38097523355).
- `ci-wait-merge.sh` could not report a result. On this host the bot token cannot read `statusCheckRollup`, so every `gh pr view` it ran failed until its background run was stopped at the time limit. I polled the Actions runs API for the head commit instead.

**Not done:**
- I skipped the panel's optional should-fix items: justifying the `tools` axis in the PR body, a narrower hook than the Proxy, rejecting malformed or unknown allowlist entries, and regrouping the commits.
- My inbox could not be read this run because the journal clone timed out.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1491135 cached reads)
- Output: 14384 tokens
- Cost: $1.2077870000000002
- Wall-clock: 1106s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
