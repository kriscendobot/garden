Panel round 5 on endojs/endo-but-for-bots PR #1397 ended **must-fix**, and the verdict is posted on the PR. I checked again on this resume that the review is there.

Last session finished the work, but the report put the stage marker after the completion signal, so the job was not recorded as done. This report puts the completion signal last.

- **Run:** I ran the panel in single-round mode on an isolated checkout of head `ed37d3c9c5`, against the PR's pinned base `b0778fab75`. `panel.sh` exited 0 with disposition `must-fix`. All 33 seats returned a verdict: 23 approve, 6 comment-only, 4 request-changes. The run record is at `panel-runs/endojs-endo-but-for-bots-1397/c1d0d899d831.md`.
- **Posted:** review id 5400856792 on commit `ed37d3c9`. It starts with the `<!-- garden-panel-verdict: must-fix -->` marker. GitHub refused a request-changes review because the bot opened this PR, so it posted as COMMENTED, as earlier rounds did. The full aggregate (82KB) is over GitHub's size limit, so the review is a curated version (~19KB), the same shape as round 4.
- **Blocking findings:**
  - **stylist:** the new test file has a `spell-out-exempt: swissNum` comment copied from another file, and `swissNum` never appears in the test file.
  - **integrator:** the PR body says "no API changes", but the public `NonceLocator.get` now accepts `string | Uint8Array`. As a should-fix, it also asks to regroup the round-by-round commits, which add and then undo the same changes, before un-drafting.
  - **scribe:** no top-level comment summarizes the response to round 4.
  - **coverage-auditor:** the PR body doesn't say why `packages/ocapn` has no real XS test.
- **Non-blocking:** a speed concern from round 1 about the exception-based ASCII check in `lookupSecretBytes` was never measured or declined, and should get a recorded decision. `NonceLocator` is not re-exported from `index.js`; that gap predates this PR. A fast-check property test for the ASCII/bytes boundary is suggested as a follow-up.
- **Code:** no seat found a logic, security or wire-format problem. Two seats ran the new test file (11/11 pass) and found `lint:types` clean.

Per the job, I did not fix anything or un-draft the PR, and I made no commits.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (983728 cached reads)
- Output: 7046 tokens
- Cost: $1.6603437999999997
- Wall-clock: 911s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
