## Fix round 1 for PR #1349: both must-fix items are fixed, and CI is green

PR: https://github.com/endojs/endo-but-for-bots/pull/1349 (head is now `9b3f9a9bd9`). The round-1 panel (integrator seat, plus the template pre-pass) had two must-fix items. Both are done.

1. **The PR body did not follow the template.** I rewrote it with the template's headings in order: Description, then the Security, Scaling, Documentation, Testing, Compatibility and Upgrade Considerations sections. It now has `Refs:` lines pointing at endojs/endo#3322 and the design doc. The design-phase ledger moved under Description. The test results and the note that "current `xst` defines both codecs" moved under Testing. The line saying no changeset is needed moved under Documentation. Sections where nothing applies get one sentence each.
2. **The CI commit was out of scope and not mentioned.** I kept `d98467c6b5` (the `dorny/paths-filter` pin comment changed to `# v3.0.3`) rather than splitting it into its own PR. The Description now says it is carried here to unblock CI's zizmor audit and that the pinned SHA does not change.

I also made one of the optional suggestions:
- **Added comment-only item #4:** new commit `9b3f9a9bd9`, `test(ses): assert XS compartments share the hardened text codecs`. When a codec is present, `packages/ses/test/_xs.js` now also checks that the new compartment sees the same `TextEncoder`/`TextDecoder` object as the start compartment. After building `ses`, `yarn test:xs` passes locally on `xst`, and prettier and eslint are clean.

The push went through `safe-push-pr-head.sh`, which moved the head from `d98467c6b5` to `9b3f9a9bd9` without rewriting history. `ci-wait-merge.sh --no-merge` returned rc=0: all 15 checks passed, 0 failed.

**Not done:** should-fix #3, the sweep of other floating `# vN` comments such as `browser-test.yml:59` `# v5`. That is more unrelated CI churn, and those comments name major tags rather than mismatched ones, so nothing is failing today. It can be a separate CI-pin PR if wanted.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (936425 cached reads)
- Output: 6388 tokens
- Cost: $0.744717
- Wall-clock: 1910s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
