# Clean stage report: endojs/endo-but-for-bots PR #1401

The clean stage is done. I added the missing regression tests and pushed them, and CI is green on the new head `b67afd6db8` (33 checks, 0 failed; `ci-wait-merge` exited 0).

**Coverage gap found:** the PR fixes the "iterator abandoned before its first pull" leak by adding `.catch(() => {})` in four exo-stream iterators. Only `iterateReader` had a regression test; `iterateWriter`, `iterateBytesReader` and `iterateBytesWriter` were changed the same way but had none.

**What I pushed:** one commit, `b67afd6db8` (`test(exo-stream): cover abandoned-iterator rejection for writer and bytes iterators`). I pushed it with `safe-push-pr-head.sh` as a fast-forward from `9b5029dc94`.
- It adds a matching `test.serial` case to `packages/exo-stream/test/writer.test.js`, `bytes-reader.test.js` and `bytes-writer.test.js`.
- Each case does three things:
  - Its fake peer's `stream`/`streamBase64` rejects before the first pull.
  - The case asserts that no unhandled rejection is reported.
  - It then confirms that a later `next()` still gets the error.

**Checks I ran locally:**
- The 4 exo-stream test files pass: 104 tests.
- With the three `.catch(() => {})` lines temporarily removed, all three new tests fail with an unhandled rejection. They pass again once the lines are restored.
- eslint is clean, the package's `tsc` passes, and prettier was applied (it only reformatted the added lines).

**Dead code:** none. The daemon change only moves the `updateRecordedPid()` call earlier, so nothing was left unused.

**Follow-ups:** none for this stage. The PR is still a draft, waiting for the next gauntlet stage (panel review).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1401-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1584911 cached reads)
- Output: 7622 tokens
- Cost: $1.0043822
- Wall-clock: 2951s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
