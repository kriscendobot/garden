Implemented and pushed commit `b93d845` to `fix/claude-cli-production-enable` (PR #150).

- Added feature-gated post-restart verification for rendered `ENDO_CLAUDE_*` settings, the exact configured `MemoryMax`, enabled CLI-wiring startup log, and a non-404 `/account/claude/<nonce>` response.
- Enforced the requested 1 GiB minimum; the current branch intentionally configures 1536M for concurrent probe/inference processes.
- Failures retain the existing failed artifact and print environment, memory, route, and journal diagnostics before rollback.
- Verified: `bash -n`, `git diff --check`, typecheck, 802 tests, and all three PR checks passed.
- Live production behavior remains unverified until this branch is deployed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-claude-production-deploy-verification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 528s

<!-- garden-usage-end -->
