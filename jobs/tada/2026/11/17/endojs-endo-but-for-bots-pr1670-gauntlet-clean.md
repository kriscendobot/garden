The clean stage for endojs/endo-but-for-bots#1670 is done: CI is green on the new head `051dfe7bdd` (all 36 checks, 0 failed).

**What was wrong:** at the old head `622979b313`, `test-xs` was red because one hardened262 baseline entry flipped from passed to failed: `sesNode/module … ThrowTypeError/intrinsic-metadata.js`. The PR didn't cause this. CI's `lts/*` Node now resolves to Node 26, and it hits every PR that runs `test-xs`. The fix is commit `d82988084a` on PR #1559, but it hasn't landed on `llm` or on this PR's base `llm-0368767`.

**What I changed:**
- I cherry-picked `d82988084a` onto the PR head. It moves that one test line from the sesNode/module `passed.txt` to `failed.txt`. I pushed it with `safe-push-pr-head.sh` as a fast-forward, `622979b313` → `051dfe7bdd`.
- No other code changes.

**Coverage pass on `packages/lal`:** 203 tests passed and 1 was skipped. The new `transcript.js` is at 99.65% statements and 91.83% branches. The only uncovered line, 89, is the no-op `close()` that the WriterFs interface requires, so it isn't dead code. The removals in `agent.js`, `inbox-loop.js` and `setup.js` left nothing orphaned, so I removed nothing.

**CI wait:** I waited in repeated bounded foreground runs of `ci-wait-merge.sh` (about 75 minutes in total), with the macOS legs finishing last. The final run returned rc 0.

**Follow-ups:**
- The PR now carries an unrelated one-line hardened262 baseline commit. Once #1559 or the same fix lands on `llm`, a later weave will absorb it.
- `llm` itself still lacks the fix, so other PRs that run `test-xs` will keep failing the same way until it lands.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1670-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2347350 cached reads)
- Output: 8276 tokens
- Cost: $1.164502
- Wall-clock: 4492s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
