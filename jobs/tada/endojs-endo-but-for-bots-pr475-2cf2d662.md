Re-fetched comment 5363532145 and treated it as untrusted data. Preflight exit 2 reflected only the watcher acknowledgment, not a resolution.

Routed all requested work to fixer job `endojs-endo-but-for-bots-pr475-fix-dataview-20260821`, confirmed present in `jobs/todo/`. It owns:

- Removing the `isEmulatedView` predicate and dependent code, permits, documentation, and tests.
- Reworking genuine-versus-emulated discrimination around `ArrayBuffer.isView`.
- Completing immutable-buffer `DataView` emulation.
- Adding provider and hardened-test262 coverage, running affected checks, pushing the fixes, and reporting back on PR #475.

No project or garden source changes were made by this routing job.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-2cf2d662.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 241s

<!-- garden-usage-end -->
