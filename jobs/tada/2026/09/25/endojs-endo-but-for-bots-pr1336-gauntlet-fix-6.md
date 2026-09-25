## Gauntlet fix round 6: endojs/endo-but-for-bots#1336

I fixed both must-fix items from panel round 6 and pushed them to the PR head. CI is green: all 33 checks passed, none failed (`ci-wait-merge` returned rc 0).

**Must-fix items fixed:**
- **fast-checker #1** (`13f042cd07`): I replaced the example tables in `packages/agent-mcp-stdio/test/agent-interface.test.js` with fast-check property tests for `toMessageNumber`. They check that:
  - every non-negative safe integer, and its plain and `+` string forms, converts to the matching bigint;
  - any natural-number digit string is accepted, including values beyond the safe-integer range;
  - non-integer, negative, too-large and non-finite numbers are rejected;
  - negative-integer strings are rejected.

  The malformed-string examples (`'0x10'`, `'++7'`, whitespace, `-0`, `'007'`, and so on) stay as examples. I added `@fast-check/ava` as a devDependency, and the lockfile change is in its own `chore: Update yarn.lock` commit (`1761ccdde6`).
- **surfacer #1** (`05c0037634`): the "Scoped imports" block in `packages/agent-tools/README.md` now includes `@endo/agent-tools/adapters/mcp.js` (`makeMcpToolServer`, `makeToolCatalog`, `renderAllowedTools`).

**Scribe's summary item:** I posted a top-level summary comment covering the earlier `M.safeInteger()` push (`ec290401c5`, `ba172a64fa`) and this round: https://github.com/endojs/endo-but-for-bots/pull/1336#issuecomment-5827632023

**Checked before pushing:**
- The package's 51 tests pass, including the 5 new `toMessageNumber` tests.
- eslint shows no new warnings, only existing ones.
- `lint:types`, the repo-root `tsc` check, and prettier are all clean.
- Regenerating the composite tsconfig files produced no changes.

The PR head moved from `ba172a64fa` to `05c0037634` through `safe-push-pr-head.sh`.

**Follow-ups:** None needed now. Fast-checker's three optional suggestions were left for later: property tests for `M.safeInteger()`, for `serveStdio` chunking, and for `renderToolResult` round-tripping (which first needs fast-check added to `agent-tools`). The driver posts panel round 7 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1582759 cached reads)
- Output: 9016 tokens
- Cost: $1.0662878000000005
- Wall-clock: 2282s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
