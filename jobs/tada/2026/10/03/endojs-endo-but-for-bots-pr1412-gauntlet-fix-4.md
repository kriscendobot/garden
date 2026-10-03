Fix round 4 for endojs/endo-but-for-bots PR #1412 is done: every must-fix item from the round-4 panel has a fix on the PR, and CI is green.

- **No new code from this attempt.** An earlier claimant of this job had already pushed two follow-up commits on top of the reviewed head `0bf0292c05`, and I didn't change them:
  - `cd60db6671` — fix(claude): close the round-4 panel's backend findings
  - `b1dd5c8a71` — docs(claude): name the maxBudgetUsd ceiling and the phase-1 result tags
- **What those commits fix:**
  - **assessor:** a late exit event after a killed turn no longer starts a grace timer that nothing clears.
  - **stylist:** `env` is renamed to `environment`.
  - **purist:** when the credential source rejects, the error detail is now a fixed string. It no longer copies the rejection's message, which could contain the credential.
  - **benchmarker:** the CLI line decoder now scans only each new chunk, so a long line without newlines costs linear time instead of quadratic.
  - **spec-keeper and benchmarker:** the SDK output-byte count only treats true cycles as repeats, so a shared subtree is counted in full.
  - **breaker:** a message id replayed across tool results now counts as separate turns against `maxTurns`.
  - **integrator:** the design doc and README now describe the `maxBudgetUsd` ceiling and how the phase-1 result tags relate to the new ones.
- **Summary comment:** I posted the top-level follow-up comment the panel said was missing. It covers both the round-3 and round-4 fixes, says which comment-only items were left alone, and gives CI status: https://github.com/endojs/endo-but-for-bots/pull/1412#issuecomment-5966452851. The round-3 part was written from the panel's notes and the commit titles, not from re-reading the round-3 diff.
- **CI:** `ci-wait-merge.sh --no-merge` exited 0, with 33 checks and none failed on head `b1dd5c8a71`.
- **Left for later:** three comment-only notes are untouched: the SDK confinement-parity caveat, the `M.any()` return guard on `UsageSink.write`, and the suggestion to use a monotonic clock for `now`. The driver will post panel round 5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 120 tokens (5163334 cached reads)
- Output: 26032 tokens
- Cost: $2.8623228000000003
- Wall-clock: 3984s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
