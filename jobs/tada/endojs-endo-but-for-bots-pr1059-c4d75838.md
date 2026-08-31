Reviewed PR #1059 and posted reviews:
- Initial review: https://github.com/endojs/endo-but-for-bots/pull/1059#pullrequestreview-5062998337
- Current-head follow-up: https://github.com/endojs/endo-but-for-bots/pull/1059#pullrequestreview-5063003846

Reproduced a P1 persistence defect on `0f6ffb0`: resumed `Intl.Segmenter` iterators lost callability. The branch concurrently fixed it in `3e77f687`; I inspected the fix and ran `cargo test -p ironhorse-snapshot --test boot_native_identity -- --nocapture`, with all 3 tests passing on `cfb3099`.

No repository changes were made. CI for the new head was still running. The design ledger retains P2-2 through P2-4 as follow-up work, so I did not approve the draft.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1059-c4d75838.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 316s

<!-- garden-usage-end -->
