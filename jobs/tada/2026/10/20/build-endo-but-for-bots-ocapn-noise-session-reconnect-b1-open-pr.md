I opened the B1 draft PR: **https://github.com/endojs/endo-but-for-bots/pull/1515**. I didn't change any code.

- **PR state:** the PR is a draft. Its head is `build/ocapn-noise-reconnect-protocol-conformance` at f8e6e488a, and its base is the frozen `build/ocapn-noise-heartbeat-capability-362dd9e` (362dd9e). Both branches were already on the remote, as the job said.
- **Body had to be reshaped:** the first `ensure-pr.sh` run refused the body from the job spec. It didn't follow the repo's PR template: the template's headings were missing and the spec's own headings weren't allowed. I moved the same content under the template's headings:
  - The rule table, the fault-injection notes and the "not in this PR" list are now under **Description**.
  - The verification results are under **Testing Considerations**.
  - Each of the other sections has a one-line "test-only / none" statement.
  - I added `Refs: #1512, #1483` at the top.
  - No facts were added or dropped.
- **Job marker:** I passed the original job base (`build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-conformance-tests`) to `ensure-pr.sh`, and I checked that the PR body carries its marker.

**Follow-up:** `ensure-pr.sh` logged that it found no `work/build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-conformance-tests` record on the board, so the PR number wasn't recorded against that job. The marker in the body should still let the completion and gauntlet steps find the PR. If the gauntlet isn't staged on its own, someone needs to run **run the gauntlet #1515**.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-but-for-bots-ocapn-noise-session-reconnect-b1-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (352139 cached reads)
- Output: 4233 tokens
- Cost: $0.5545758000000001
- Wall-clock: 77s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
