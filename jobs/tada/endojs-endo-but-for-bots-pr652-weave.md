Rebased and force-pushed `feat/mount-cli-denied-segments` onto `llm` at `b8948b8df`.

The daemon/revocation commits and both zizmor pin commits were already represented on `llm`, so rebase skipped them; the PR now contains only the two CLI commits.

Focused verification passed:
- daemon `mount-revocation.test.js`: 24 passed
- CLI `mount-deny.test.js`: 7 passed

Full package test commands were attempted but blocked by the worktree’s no-exec dependency mount (`ava` / `better-sqlite3` permission denied). GitHub now reports `mergeable: true`; pull-request workflows dispatched on the new head. CI remains unstable with existing `lint` and `sandbox-drivers` failures for a shepherd follow-up.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr652-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 36413 tokens (736512 cached reads)
- Output: 15847 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 7215s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
