Completed endojs/endo-but-for-bots#762.

- Ran four full code-panel rounds; addressed all blocking findings. The final panel passed and was posted as a commented review because GitHub forbids self-approval.
- Consolidated the implementation at `f129f92247a`, hardened pathspec/CRLF handling, expanded regression coverage, aligned naming and documentation, and integrated the checks into root scripts.
- Preserved frozen base `master-77d9d0c`; no duplicate PR was created.
- Verified `yarn test:lint-file-names`, `yarn lint`, mutation checks, and all 14 GitHub CI checks.
- Un-drafted only after the passing panel. The PR is open, mergeable, and ready for review.
- Nonblocking follow-ups include possible property-based testing and stale-exemption validation.
- Self-improvement: reported the stale same-head panel-resume behavior after comment-only resolutions to `role/gardener`.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/762 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr762-gauntlet-20260902.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (4 engagement(s) unpriced)
- Wall-clock: 3300s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
