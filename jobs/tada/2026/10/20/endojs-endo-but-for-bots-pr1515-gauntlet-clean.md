The clean stage for PR #1515 (endojs/endo-but-for-bots) is done: nothing needed changing, so this stage made no changes.

- **What the PR is:** a draft, open PR titled "test(ocapn-noise): reconnect protocol conformance tests (B1)", head `f8e6e488` on `endojs:build/ocapn-noise-reconnect-protocol-conformance`. It touches one file, `packages/ocapn-noise/test/reconnect-protocol.test.js`.
- **No changes needed:** the PR only adds tests, so there was no new source code for a coverage pass to cover and no dead code it could have orphaned. I did not make a project checkout and pushed nothing.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1515 --no-merge` returned rc 0: all 35 checks finished with 0 failures (some were skipped). The `cover` (22.x, 24.x) and `test` matrix jobs passed.
- **Follow-ups:** none from this stage. The next gauntlet stage (panel review) can go ahead.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1515-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (104849 cached reads)
- Output: 971 tokens
- Cost: $0.3278938
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
