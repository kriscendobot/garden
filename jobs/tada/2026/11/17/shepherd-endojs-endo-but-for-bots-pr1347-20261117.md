PR #1347 (`build/endo-gateway`) now passes CI: on the new head `4e336f2506`, all 26 checks succeeded, 10 were skipped, and GitHub reports it as mergeable. It is still a draft.

**The one failure:** in the post-weave run (43997648419) on head `ff05a375ad`, only `test-xs` failed. Every other job passed, including all four `test` legs, both `cover` legs, `lint` and `test-thixotrope-ironhorse`. The failure came from `@endo/hardened262` `test:xs`: the result for `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` flipped from passed to failed. The gateway change didn't cause it. `.node-version` is `lts/*`, which CI now resolves to Node 26.13.1, and that version's V8 sets up the `caller` accessors on functions differently, so the stored baseline no longer matches.

**The fix:** commit `d82988084a` already records this new result in the baseline, but it sits on open PR #1559 and hasn't reached `llm`. I cherry-picked it with `-x` onto the PR head as `4e336f2506`. It moves one line from `passed.txt` to `failed.txt` in `packages/hardened262/baseline/sesNode/module/` and nothing else. I pushed it to `build/endo-gateway` as a fast-forward from `ff05a375ad`, after the first run had finished so the push didn't cancel tests in progress. No gateway code changed.

**Follow-ups:**
- Until `d82988084a` (or #1559) lands on `llm`, every `llm`-based PR's `test-xs` job will keep failing the same way. Landing that baseline fix on `llm` by itself would clear it for all of them.
- When #1559 or `llm` picks up that commit, #1347 will carry a duplicate of it. A later weave should treat it as already applied and drop it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1347-20261117.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1770669 cached reads)
- Output: 9256 tokens
- Cost: $1.0310777999999998
- Wall-clock: 6803s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
