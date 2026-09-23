Implemented and pushed commit bf40a3b05a31d3f0ee7fad1ed07fe84eaa9af5b0 to PR #475.

Changed the immutable ArrayBuffer shim to use a first-evaluation-wins realm sentinel and private-brand predicate, eliminating eval-twin WeakMap divergence. Updated byte readers, pass-style validation, SES permits, documentation, and regression coverage. Added Node Test262 parity cases and a direct XS 17.9.1 end-state test.

Validation passed: immutable-arraybuffer 239 tests, bytes 132 configurations/tests, pass-style 54 configurations/tests, relevant lint/type checks, six Node Test262 scenarios, and direct XS parity.

Posted the resolution: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5360413466

No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-67703d8c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2373s

<!-- garden-usage-end -->
