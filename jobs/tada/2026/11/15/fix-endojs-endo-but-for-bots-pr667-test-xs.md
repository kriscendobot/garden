PR #667 is green again: every check passed on the new head `68bbfb0a15`, including `test-xs`, `zizmor` and all four `test` matrix legs.

**Cause:** the `test-xs` failure was not caused by the PR. It failed with "Result baseline changed": `@endo/hardened262` `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` went from passed to failed. CI's `.node-version: lts/*` now resolves to Node 26, which gives `Function.prototype.caller` its own get/set accessors instead of reusing %ThrowTypeError%. The same check also had a red `zizmor`, from the `create-pull-request` action's floating `# v8` version comment after upstream moved its v8 tag.

**Fix:** I cherry-picked the two existing fixes from #1559 onto `feat/genie-stdio-jsonl-rpc-bridge` and force-pushed with a lease against the previous head `9b70df7f8e`:
- `3df7ded22d` (from `d82988084a`) moves the ThrowTypeError line from `baseline/sesNode/module/passed.txt` to `failed.txt`.
- `68bbfb0a15` (from `22580d5a4d`) changes only the version comment in `update-action-pins.yml` and `update-action-pins-major.yml` to `# v8.1.1`; the pinned action is unchanged.

The PR's own code is untouched, so the stdio JSONL RPC bridge stays within its M3 scope. I made no garden (`main2`) changes.

**Follow-up:** `llm` itself still lacks both fixes, so every PR that runs `test-xs` or `zizmor` keeps hitting these failures until they land on `llm` (through #1559 or a direct commit).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr667-test-xs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1202699 cached reads)
- Output: 5854 tokens
- Cost: $0.8712198000000002
- Wall-clock: 3802s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
