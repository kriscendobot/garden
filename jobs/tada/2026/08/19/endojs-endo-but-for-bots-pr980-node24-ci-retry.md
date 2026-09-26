PR #980 is already **MERGED** (2026-08-17), so this CI-shepherding job is moot.

Re-derived state:
- PR #980 (`feat(ascii): add strict decoding and adopt for OCapN`) is in state **MERGED**.
- The Node 24 infrastructure blocker was resolved upstream by the repository's CI pin: the Node 24 legs now run as **`test (24.18.0, ubuntu-latest)`** / `test (24.18.0, macos-15)` / `cover (24.18.0, ...)` / `test262 (24.18.0, ...)` / `viable-release (24.18.0, ...)` — all **SUCCESS**. The old bare `test (24.x, ubuntu-latest)` leg that reproduced the Node 24.19.0 + better-sqlite3 cleanup-hook assertions is gone.
- Every check in the final rollup is SUCCESS; the PR merged.

No action needed: the feature branch was never touched (per spec, since the failure was infra-tied, not diff-tied), CI is fully green, and the review-request/summary step is unnecessary because the PR is already merged. The shepherding objective — drive CI to green — is satisfied by the merge.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr980-node24-ci-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (3 unmetered)
- Input: 4 tokens (59344 cached reads)
- Output: 873 tokens
- Cost: $0.371653 (3 engagement(s) unpriced)
- Wall-clock: 37s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
