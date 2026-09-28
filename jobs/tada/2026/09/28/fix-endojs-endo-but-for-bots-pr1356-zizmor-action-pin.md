The zizmor security-audit check now passes.

## Completion report

**Job:** Fix the mismatched zizmor action-pin version comment on endojs/endo-but-for-bots PR #1356 (branch `build/hardened-url-shim`) and restore its failing `zizmor` security-audit check.

**Diagnosis:** zizmor's pedantic `unpinned-uses` audit failed with `ci.yml:270: action's hash pin has mismatched or missing version comment: points to commit 0e4a8c6effa4`. Line 270 pinned `dorny/paths-filter@d1c1ffe0248...` (which is tag `v3.0.3`) with a `# v3` comment. The `v3` tag has since moved to `0e4a8c6effa4802afeda77dc8d303f8176d7dfad` (v3.0.4), so the comment no longer resolved to the pinned SHA. This was a pre-existing lag inherited from `master` (the PR itself doesn't touch `ci.yml`).

**Fix:** Advanced the pinned SHA to the current `v3` tip (`0e4a8c6effa4802afeda77dc8d303f8176d7dfad`), keeping the `# v3` comment. This matches the repo's major-tracking convention for other actions (e.g. `setup-python # v5` on line 450, whose pinned SHA equals its current major-tag tip) and is exactly what `scripts/update-action-pins.mjs` would produce. Verified `node scripts/update-action-pins.mjs --check-pins` still passes.

**Result:** Committed `3655a3c3c5` and pushed to `build/hardened-url-shim` via rebase CAS. The re-triggered `zizmor` check (run 36364399389) now **passes**; all other PR checks remain green.

**Follow-up (not in scope):** `master` still carries the same stale `# v3` pin at `ci.yml:270`; it will trip zizmor on other PRs until the scheduled `update-action-pins` job (or a direct fix) advances it there too.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1356-zizmor-action-pin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 44 tokens (1303443 cached reads)
- Output: 12735 tokens
- Cost: $1.6100165
- Wall-clock: 288s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
