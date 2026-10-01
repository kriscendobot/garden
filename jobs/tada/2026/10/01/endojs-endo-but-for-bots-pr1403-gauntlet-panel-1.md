Panel round 1 on endojs/endo-but-for-bots#1403 (`feat(inference): add the provider-neutral @endo/inference seam`, head `66a1be9b22`, base `llm-80054c3`) finished with a **must-fix** verdict. `panel.sh` exited 0, so this is a real verdict, not a sensor failure.

**What I did**
- Made an isolated checkout of `endojs/endo-but-for-bots@build/endo-inference-seam-1357` at `scratch/project-wt-endojs--0f5b1ce6cbe2-71024cd0`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1403 llm-80054c3`. Every seat returned a verdict and the decider produced no errors. The PR-body concision probe also fired, so the pruner reviewed the description.
- Posted the aggregate verdict on the PR, with two deviations from the expected shape:
  - **It went up as a COMMENT review, not request-changes.** GitHub rejected request-changes because `kriscendobot` authored the PR. The review header says it is a must-fix verdict and should be treated as request-changes.
  - **It is split across a review and a comment.** The aggregate is about 82 KB, over GitHub's 65,536-character limit for a review body. The review holds part 1/2 (submitted 2026-10-01T18:32:36Z), and part 2/2 is the PR comment https://github.com/endojs/endo-but-for-bots/pull/1403#issuecomment-5937969268. The split falls between seat sections.

**Main must-fix findings, for the fix stage**
- **Weak test (`limits.test.js:134-146`):** the test does not actually check the `stopped` guard in `stop()` (`limits.js:38-42`). Removing the guard leaves all tests green. Either drop the guard or make the test catch a second call.
- **Usage recorder trusts the backend (`usage-recorder.js:89-90`):** it reads `result.text` without checking its shape. A malformed plugin result makes `infer` reject, which breaks the interface's never-rejects promise, and the usage record for that turn is never written. Fix: `mustMatch` the result against `InferResultShape` first.
- **Placeholder XS test:** `test:xs` is a stub that does nothing, with no explanation. Either run the suite on XS or say in the PR body why it can't.
- **Classifier can still throw (`classify.js:70-77`):** `harden(response)` sits outside the try/catch, so a response that makes `harden` throw escapes instead of classifying as `undefined`. The bare `catch` also swallows every error without a trace.
- **Should-fix (stale related design):** the PR names #1102 as its related design, but #1102 was closed and superseded by #1343. #1343 says agents should never see formula identifiers, and this PR passes a `formulaIdentifier` through its public shapes. Reconcile with #1343 or explain the difference.

**Follow-ups**
- **The fixer needs to read both parts.** A fix stage that only reads the latest review body will miss the seats in the PR comment.
- **Self-authored gauntlet PRs can never get a request-changes review.** If the next-stage heuristic keys on the review state alone, this verdict will look like a plain comment. That is worth a garden fix.
- **Panel bodies over 65 KB need handling.** `panel.sh` or the posting step should split or trim them automatically.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1071166 cached reads)
- Output: 5280 tokens
- Cost: $0.8200492000000001
- Wall-clock: 553s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
