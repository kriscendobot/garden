**Retro for endojs/endo-but-for-bots#1290, review 5229123005: recorded as a miss, and the cluster's improvement job is posted.**

**Verdict: miss** (category `test-gap`, minor severity)
- **What kriskowal asked for** (my paraphrase): an end-to-end Playwright case in the repo's top-level `browser-test/` suite. It should bundle `@endo/sha256` through the compartment mapper under the `browser` condition and prove the browser bundle gets working sync and async sha256. The builder (job `endo-sha256-async-arm-followup`) had tested the new WebCrypto `browser` arm only with Node-side spies.
- **Why this counts as a miss and not new direction:**
  - The `browser-test/` Playwright harness already existed on `llm` when the PR was built (`canary.spec.js`, `chat-smoke.spec.js`).
  - The same package had already drawn this kind of feedback on #836, which is the first member of the existing `cross-platform-test-coverage` cluster.
- **Who missed it:** no panel ran before the review. The PR was a builder draft waiting for a manual "run the gauntlet", so the fault sits with the producing builder, with `coverage-auditor` as the seat that should gain the check.
- **Did the primary job really fix it?** Yes, checked against GitHub rather than its report. `browser-test/tests/sha256.spec.js` is in the merged PR's file list (the primary job reports it as commit 3e84158dc), and #1290 merged on 2026-09-21. No discrepancy with the primary.

**Record and cluster**
- The record is at `review-misses/misses/endojs-endo-but-for-bots-pr1290-review-fe19b903.md`. It holds a paraphrase and the review URL, not the raw comment text.
- It joined `cross-platform-test-coverage`, which now has 3 misses across PRs 836, 475 and 1290. This is not a recurrence, because the cluster was still open.

**Threshold and dispatch**
- The floor (3 misses across at least 2 PRs) is met. The members fit together: each is a platform arm (xs, browser, or native-vs-shim) whose tests never ran on that platform. Two are the same package, so the lesson from #836 didn't take hold by #1290. No improvement job was already open.
- I posted builder job `review-improve-cross-platform-test-coverage` (identity `review-cluster:cross-platform-test-coverage`). It carries both required parts:
  - **Prevention:** a producer rule that a new `browser`/`xs`/`endor` conditional-export arm must ship with a test that runs on that platform. For `browser` on this repo, that means the `browser-test/` Playwright suite bundled through the compartment mapper. The PR body must say why if such a test isn't possible, and shim-only assertions need a native-detection guard.
  - **Sensing:** a panel-hints probe that fires `coverage-auditor` and `engine-realist` on new condition keys, platform-specific source files, or `test:xs` scripts that are `exit 0` stubs, plus a matching check line in the seat brief.
  - It closes with a re-litigation test against the diffs of #836, #475 and #1290.
- The cluster is now marked `improvement-dispatched`, with the rationale recorded.

**Follow-up:** `review-improve-cross-platform-test-coverage` is on the board. It closes the cluster when it finishes.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-review-fe19b903-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (713195 cached reads)
- Output: 7028 tokens
- Cost: $0.789671
- Wall-clock: 179s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
