---
handed-off: finish-recursive-dynamodb-capabilities-1545
deliverable-complete: false
---
Adopted existing draft PR https://github.com/endojs/endo-but-for-bots/pull/1545 at commit `95ff807a`.

The implementation predates the latest design revision and is not contract-complete. Key gaps include the revised derivation/control APIs, nested restrictions, index range enforcement, restart semantics, and required integration/confinement coverage.

- Ran `yarn workspace @endo/exo-dynamodb test`, lint, and build: 11 tests passed; all commands exited successfully.
- CI failures inspected were unrelated sandbox-runner and missing-`tred` failures.
- Posted successor job `finish-recursive-dynamodb-capabilities-1545`, which owns reconciliation with design commit `d65ac219` and completion of the existing draft PR.
- No additional source changes were made.

Self-improvement: the implementation job should pin the reviewed design commit so late design revisions cannot silently invalidate an in-flight build.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-design-recursive-dynamodb-capabilities-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2552s

<!-- garden-usage-end -->
