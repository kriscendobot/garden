**Shepherd report: endojs/endo-but-for-bots #1575 (`feature/api-key-provider-adapters`). CI is green.**

**Result:** Head `096598354304` passes every check: 19 pass, 17 skipped (the ironhorse and wasm jobs this change doesn't trigger), none failing. All four `test` legs (Node 22.x and 24.x on ubuntu-latest and macos-15) pass, and CI run https://github.com/endojs/endo-but-for-bots/actions/runs/40855857531 concluded `success`.

**What was failing:** One test, on all four legs of run 40784744087: `packages/daemon/test/inference-provider-registry-restart.test.js` was rejected with `Inference provider operation failed: "inference-request-refused"`. It was a real regression from this PR, not a flake. The PR's new Anthropic provider accounting does two things this test didn't account for:
1. It checks every AgentInference request against the Anthropic Messages request shape. The test still sent an empty `{}` body.
2. It checks each request against agent, provider and owner budgets. The default owner budget is in dollars, and the test model `claude-test` has no price, so the owner check refuses it as `unpriced-model`.

**Fix:** One test-only commit, `0965983543`, `test(daemon): send a policy-valid request in the provider-registry restart test`. It sends a minimal valid body (`{"model":"claude-test","max_tokens":1,"messages":[]}`) and gives the owner a token budget with `setOwnerLimits({ dailyTokens: 1000 }, …)`, the same setup the hosted-agent unit tests use. No source code changed. I pushed with `--force-with-lease` against the old head `e5fad62c94`.

**Local checks:** The test passes locally, and prettier and eslint are clean on the file. To run it locally I had to rebuild better-sqlite3 for Node 22. The warm dep-cache had shipped a Node 24 build (ABI 137) while the container runs Node 22.23.3. I first broke the hardlink to the cache, so the rebuild only touched this job's worktree and the shared cache is unchanged.

**Follow-ups:**
- The dep-cache built its native modules for a different Node version than the container's `node`. The daemon tests can't start locally from a cold worktree until someone looks at that.
- I posted no PR comment because commenting wasn't explicitly authorized. The PR is still a draft, and Phase 3 of the API-key agent workbench is no longer blocked on red CI.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-shepherd-20261029.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2404773 cached reads)
- Output: 9485 tokens
- Cost: $1.3214226000000002
- Wall-clock: 3042s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
