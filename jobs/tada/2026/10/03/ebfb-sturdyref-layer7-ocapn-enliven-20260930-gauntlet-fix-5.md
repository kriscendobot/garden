Fix round 5 for endojs/endo-but-for-bots PR #1397 (draft) is pushed and CI is green: all 33 checks passed on the new head `8d95262f13`, with no failures.

I applied every must-fix item from the round-5 panel review (5400856792) and its should-fix item:

- **stylist:** deleted the copied `spell-out-exempt: swissNum` comment on line 1 of `packages/ocapn/test/sturdyref-enliven.test.js`. That file never uses `swissNum`.
- **integrator, must-fix:** edited the PR body.
  - The Description now says this layer only fixes the home enliven path, which the base already provides.
  - Documentation and Compatibility now describe the public widening of `NonceLocator.get` to `string | Uint8Array`. They also note that a string-keyed `Map` still type-checks against it.
- **integrator, should-fix:** squashed the five round-by-round commits into two logical commits, which needed a history-rewriting push (`safe-push-pr-head.sh --mode rewrite`, guarded by a lease on the old head):
  - `d28b6a4fe7`: the `NonceLocator` type widening.
  - `8d95262f13`: the shared `lookupSecretBytes`, the home enliven, and its tests.

  The final file contents match the old head `ed37d3c9c5` exactly, apart from the deleted comment line.
- **coverage-auditor:** added a line to the PR body explaining there is no XS run. The package's `test:xs` script is a stub, and the package depends on Node-only modules.
- **scribe:** posted a summary comment covering both the round-4 and round-5 responses (https://github.com/endojs/endo-but-for-bots/pull/1397#issuecomment-5970014463).
- **benchmarker, non-blocking:** that comment declines the round-1 suggestion to replace the exception-based ASCII check, without measuring it. The exception only fires on secrets that aren't all ASCII, which is the uncommon path. The `try` also has to stay so the decoder's error message, which names a byte of the secret, doesn't escape.

Locally, `yarn ses-ava test/sturdyref-enliven.test.js` passed 11/11 and eslint is clean on the changed test file.

Two non-blocking suggestions are not done and are listed as follow-ups in the comment: re-exporting the `NonceLocator` type from `index.js` (curator; the gap predates this PR) and a fast-check property test for the ASCII/bytes boundary (fast-checker).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 42 tokens (1287743 cached reads)
- Output: 8761 tokens
- Cost: $0.9268326
- Wall-clock: 2341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
