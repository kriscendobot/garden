**It's a real bug, and the fix is pushed to the PR branch** as `06df54821` on `feat/lal-iterative-compaction`. I didn't wait for CI on the new commit.

**Reproduction**
- **Worker lockdown:** a daemon worker runs plain `@endo/init` (`packages/daemon/src/worker-node.js`), where `Fail` redacts bare substitutions in `error.message`. The inbox loop builds the reply from that message (`packages/lal/inbox-loop.js:175`).
- **Before the fix:** the host's reply for a provider error is `/compact failed: Compaction summary stopped with (a string): (a string)`. A length stop gives `(a string): (an undefined)`.
- **Why the PR's tests missed it:** `@endo/ses-ava/prepare-endo.js` locks down through `commit-debug.js` with `errorTaming: 'unsafe'`, which turns redaction off. A test added to `compaction.test.js` saw the unredacted text with the code unfixed, so it can't catch this.

**Changes**
- **`packages/lal/compaction.js`:** `requestSummary` now wraps both values in `q(...)`, and a missing `errorMessage` becomes `'no error message'` instead of q's `"[undefined]"` placeholder.
- **Replies now:** `...stopped with "error": "provider down"` and `...stopped with "length": "no error message"`.
- **`packages/lal/test/compaction-production-errors.test.js` (new):** runs under plain `@endo/init` and drives a failed summary through `runInboxLoop` to the host's reply. It also asserts that this lockdown really does redact, so the test can't quietly stop testing anything.

**Verification**
- **New test file:** both reply tests fail on the unfixed `compaction.js` with the redacted text above, and all 3 tests pass with the fix.
- **Full `packages/lal` ava suite:** 244 passed, 1 skipped.
- **Lint and types:** `yarn tsc --noEmit` exits 0 and prettier is clean. ESLint reports 0 errors and 4 warnings: 2 in the new test and 2 on `compaction.js` lines the fix doesn't touch.
- **Push order:** the typecheck ran just after the push, because my first attempt with `npx tsc` never started the compiler.

**Other `Fail` calls, left unchanged**
- **Settings errors:** `readTokenCount` (`compaction.js:40`) and `LAL_COMPACTION_ENABLED` (`compaction.js:61`) also use bare substitutions. They run in `spawnWorkerLoop`, whose rejection only goes to `console.error`, so they should never reach the host's reply.
- **Remaining `Fail` calls in `compaction.js`:** none of them substitute values.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1644-gauntlet-fix-1-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (668588 cached reads)
- Output: 14257 tokens
- Cost: $1.0003056000000001
- Wall-clock: 1232s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
