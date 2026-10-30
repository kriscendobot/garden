**Report: PR #1425, pre-spend viability**

PR #1425 (XS: start `Compartment` built from lockdown intrinsics) is open, draft and unmerged. It is based on the branch `fix/zizmor-paths-filter-pin-comment-1b1ead4`, which is PR #1427's branch. #1427 is also open and not a draft.

Deciding question: Has a newer implementation landed on `llm` or `master` that builds the XS start `Compartment` from the lockdown intrinsics, or does the premise no longer hold? No to both.

Evidence:
- `packages/ses/src/compartment-shim.js` on both `llm` and `master` still builds the shim `Compartment` at import time from `getGlobalIntrinsics(globalThis, muteReporter)`. That is the bug this PR fixes.
- The branch is 7 commits ahead of and 0 behind `master-6ee3fda`, so it is current.
- The security premise holds: guest compartments on XS get an untamed `Date` and `Math`, so `Date.now()` and `Math.random()` work in guest code. This is independent of #1349.
- #1349, which this PR was meant to unblock, was closed on 2026-10-29. That was an automated close because its upstream mirror, endojs/endo#3377, was closed without merging. That does not displace this fix. Only the PR's "lets #1349 drop its pre-import module" motivation lapses, and the hardening holes stand on their own.
- Earlier gauntlets for this PR halted at the clean stage, 0 rounds, with CI red at the time. A later shepherd pass reported all 15 checks green at head `3158064e`.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261030-run-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (240966 cached reads)
- Output: 1692 tokens
- Cost: $0.2276606
- Wall-clock: 30s

<!-- garden-usage-end -->
