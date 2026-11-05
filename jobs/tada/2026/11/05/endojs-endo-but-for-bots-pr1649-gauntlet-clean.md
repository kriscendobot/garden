I wrote this cleanup's own fixes for PR #1649 and pushed them. CI hit the 1-hour deadline (rc 4) with two legs still running, so I'm reporting this stage as **still pending**. Two checks are red for reasons this PR didn't cause (details below), so the re-posted stage will probably come back red unless someone deals with them.

**What I fixed and pushed** (head went from `52d32b7790` to `2dd07fe5af0`, via `safe-push-pr-head.sh`):
1. **`chore: Update yarn.lock`**: `@endo/platform` was out of sorted order in the `@endo/hosted-agent` lockfile entry. CI refuses to modify the lockfile during install, so almost every check was failing on this one line.
2. **`chore(hosted-agent): regenerate composite tsconfig`**: the lint drift check failed because `@endo/promise-kit` was missing from `packages/hosted-agent/tsconfig.composite.json`. I added it by re-running the generator script.
3. **`test(hosted-agent,daemon): satisfy lint:types`** plus a follow-up fix for a bad replacement in it: the daemon's type check failed on 14 errors. I added a small `mustGet` helper for Map lookups in `hosted-agent/test/agent-factory.test.js` and type annotations for the catalog and the fake issuer's `seen` record.
4. **`style: apply prettier`**: lint's prettier check flagged 11 files in hosted-agent, daemon tests and `lal/agent.js`. I formatted them with prettier 3.9.4; the repo asks for ^3.9.10, but lint passed afterwards.
5. **`fix(hosted-agent): drop redundant return await in isPinned`** (`agent-responder-launcher-module.js`): a `no-return-await` error that was already in the code but only showed once the earlier lint failures were out of the way.

I mistakenly pushed the first commit to the bot's fork (`kriscendobot/endo-but-for-bots`) instead of the PR's branch. I deleted that stray branch right away and pushed to the correct one.

**Coverage pass:** no new tests added. The touched code already has dedicated tests: `hosted-agent/test/agent-responder.test.js` (544 lines) and `daemon/test/agent-responder-restart.test.js` (404 lines). I found no dead code left behind by the change.

**CI at the deadline (head `2dd07fe5af0`):** lint is green now. 32 of 36 checks are green or skipped. Two are still running: `test (22.x, macos-15)` and `test (24.x, ubuntu-latest)`. Two are red, neither caused by this PR:
- **`test-xs`**: one hardened262 result flipped from passed to failed (`sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js`). This PR touches neither ses nor hardened262, and the baseline files are identical to `llm`'s. It looks like a change in the CI environment, possibly the runner's Node version. The likely fix is a baseline update or an environment pin on `llm`, not a change here.
- **`test (24.x, macos-15)`**: `daemon/test/http-content-plane.test.js` failed with an unhandled `ClientDestroyedError` ("Cannot assign to read only property 'message'"). This is the known Node 24 undici × SES flake; a rerun usually clears it.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1649-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 166 tokens (7134900 cached reads)
- Output: 26677 tokens
- Cost: $2.77944
- Wall-clock: 9413s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
