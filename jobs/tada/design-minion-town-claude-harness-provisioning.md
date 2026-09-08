Added `designs/claude-harness-provisioning.md` and landed it on `main2` at `e29d7589ce8824372fd9dcc59ce6342b775eea1b`.

The design specifies Claude Code 2.1.236, architecture-specific checksums, cache-aware installation, fatal build behavior, weekly Dependabot/botanist upgrades, rollback receipts, runtime-only credentials, unconditional harness presence, and `ENDO_CLAUDE_ENABLED` gating. It also covers the current ARM64 EC2 deployment path.

Checks passed: Anthropic manifest GPG verification, five pre-push probes, `git diff --check`, and remote commit confirmation. No open questions; implementation remains a separate build job.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-claude-harness-provisioning.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 985s

<!-- garden-usage-end -->
