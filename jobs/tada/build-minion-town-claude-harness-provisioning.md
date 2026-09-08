Implemented Claude harness provisioning and opened draft PR https://github.com/kriscendobot/minion.town/pull/99 at head `507e951`.

Changes:
- Pinned Claude Code 2.1.236 with exact amd64/arm64 hashes, sizes, provenance, signing key, and redundant npm lock.
- Added signed-manifest refresh, pin-consistency checks, integrity installer, CLI-contract tests, and weekly Dependabot configuration.
- Provisioned the verified binary unconditionally in Docker and ARM64 AWS artifacts with updates disabled.
- Added content-addressed deployment artifacts, receipts, staged/post-deploy probes, and automatic rollback on failed health checks.
- Added cold multi-architecture image builds and runtime inspections to CI.
- Left Claude capability wiring and `ENDO_CLAUDE_ENABLED` behavior untouched.

Verification:
- Real Anthropic amd64 artifact: `2.1.236 (Claude Code)`, 334,645,552 bytes, SHA-256 `6c8818fa22187aa555c242be4abbacc44d6b71a32ac9631ee7b2b5d12f51f752`.
- Signed refresh reproduced the tracked manifest.
- Harness tests: 7/7 passed; checksum-bypass mutation made both corruption tests fail.
- Typecheck and application suite passed: 336 tests passed, 5 integration tests skipped.
- Pre-push gates and local verification passed.
- PR CI passed for application tests and cold/runtime image verification on amd64 and arm64.
- Live deployment was not performed; deployment smoke and receipt generation run after merge.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-harness-provisioning.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1990s

<!-- garden-usage-end -->
