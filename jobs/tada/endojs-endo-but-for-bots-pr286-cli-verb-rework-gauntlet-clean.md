CI is GREEN (rc 0, 26 checks, 0 failed). The CLEAN stage is complete.

## Completion report

**Job:** Gauntlet CLEAN stage for endojs/endo-but-for-bots PR #1014 (feat: `endo http mk` on the policy-based HTTP client).

**Re-derived state on fresh start:** PR #1014 had a failing CI `lint` check at the claimed head (all other 25 checks green). Reproduced locally on the touched `packages/cli` package: one eslint **error** — `test/http-mk-command.test.js:2 'process' is already defined as a built-in global variable (no-redeclare)`, from a redundant `/* global process */` directive. Sibling CLI tests (`formula-collection.test.js`) reference `process.pid`/`process.env` with no such directive, confirming it was unnecessary.

**What I did:**
- Removed the redundant `/* global process */` line from `http-mk-command.test.js`; `yarn lint` then reported 0 errors (the 9 remaining warnings are pre-existing in `origin/llm`, not introduced by this PR, and don't fail CI).
- Reviewed the touched source (`src/commands/http-mk.js`, `src/endo.js` subcommand wiring) for dead code — none; the change is self-contained and both the success path and the empty-allowlist rejection are already exercised by the test file. No orphaned code to remove.
- Committed (`32e4d80981`) and pushed to the PR head via `safe-push-pr-head.sh` (advanced `226b56a8bc → 32e4d80981`).
- Watched CI to terminal with `ci-wait-merge.sh --no-merge`: **GREEN**, 26 checks, 0 failed.

**Result:** coverage/dead-code clean, CI green.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr286-cli-verb-rework-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 82 tokens (2370031 cached reads)
- Output: 16937 tokens
- Cost: $2.5888565000000003 (1 engagement(s) unpriced)
- Wall-clock: 1050s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
