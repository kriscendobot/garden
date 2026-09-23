Implemented and pushed `scripts/context-graph-size-audit.py` with fixture coverage at main2 commit `7e6aae2c3424`.

The audit walked 8,300 reachable documents and flagged 355 reorganization candidates using 300-line, 24-KiB, sibling-outlier, and topic-mixing thresholds. It also reports unreachable documents and exempts the generated library sections index.

Landed report: `journal/reports/context-graph-size-audit-2026-08-13.md`.

Checks run: fixture test passed; ShellCheck passed; worktree clean. Consider scheduling periodic audits if trend data becomes useful.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/context-graph-size-audit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 360s

<!-- garden-usage-end -->
