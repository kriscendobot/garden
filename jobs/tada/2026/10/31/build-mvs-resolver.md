Opened draft PR endojs/endo-but-for-bots#1596 against pinned base `llm-9a14ddf`.

Changed `@endo/exo-npm` to:

- Select the least published version satisfying all accumulated same-major requirements.
- Avoid unrelated compatible upgrades.
- Reject incompatible same-major ranges.
- Add focused, mutation-proven regression tests.

Verification: package lint passed; 43 package tests passed; all 13 pre-push stages passed. Full-workspace verification exposed unrelated base issues in `zizmor` workflow parsing and a transient thixotrope port collision; the affected thixotrope test passed 27/27 cases when rerun alone.

Self-improvement: reported the local verifier’s false codegen-drift result on pre-existing staged changes to `role/liaison`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-mvs-resolver.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2811s

<!-- garden-usage-end -->
