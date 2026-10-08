Wove endojs/endo-but-for-bots#586 onto frozen base `master-6ee3fda` and moved the PR base. The four test commits rebased without conflicts; final head is `0b9ddf5904`.

Added one CI-only follow-up correcting the stale `dorny/paths-filter` annotation to `v3.0.3` without changing its SHA.

Verification:
- Immutable-arraybuffer: 324 tests passed, including all 96 boundary cases.
- Action-pin validation passed.
- Exact-head CI, dependency validation, and workflow-security checks passed.
- PR is CLEAN with no non-green checks.
- Posted the completion summary on PR #586.

Follow-up: ready for fresh panel/review coverage.

Self-improvement: reported the CI-trigger sequencing gotcha to `role/liaison`; no garden files changed.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/586 ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr586-weave-20261008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1501s

<!-- garden-usage-end -->
