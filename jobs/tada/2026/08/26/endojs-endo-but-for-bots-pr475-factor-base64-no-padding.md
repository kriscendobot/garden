Implemented and pushed commit `d8a6e4c356c1898c3ec53d93aab4256dcbde3ed0` to PR #475.

- Added `@endo/base64/no-padding-encode` and `@endo/base64/no-padding-decode`.
- Refactored Cap’n Web special-value codecs to use the new entry points.
- Added focused encoding, padded/unpadded decoding, and invalid-input tests.
- Added `@endo/base64` minor and `@endo/capn-web` patch changeset coverage.
- Verified `@endo/base64` lint and 10 tests; `@endo/capn-web` lint and all three 185-test SES configurations; all five staged-diff garden probes.
- Confirmed regression tests fail when either padding adaptation is removed.
- Replied inline and posted the required PR completion summary.
- GitHub CI was repeatedly restarted by subsequent concurrent commits and remained pending; review was therefore not re-requested.
- Full branch-wide pre-push gate remains blocked by pre-existing PR findings and ShellCheck rejecting its global `--fix` argument.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-factor-base64-no-padding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2125s

<!-- garden-usage-end -->
