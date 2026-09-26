Restacked the full OCapN-over-Noise stack:

- #684 rebased onto current `llm`, retargeted to `llm`, and force-pushed at `efcc498729`. Resolved the OCapN transport conflict by preserving #340’s landed implementation while integrating WebSocket transport support.
- #688 rebased onto refreshed #684 and force-pushed at `884afffb79`.
- #693 rebased onto refreshed #688 and force-pushed at `c25fe20a3d`.
- Verified ancestry is coherent: #684 → #688 → #693.
- All three PRs are OPEN, DRAFT, and MERGEABLE. CI is attached and running with no completed failures observed.
- Verification passed on each branch via the full local verification harness and all five pre-push probes. #684 additionally passed 16 focused OCapN/WebSocket daemon tests.
- Posted completion summaries on all three PRs.
- No PRs were closed or merged.

Follow-up: allow remaining CI jobs to finish.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr684-restack-onto-340.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1326s

<!-- garden-usage-end -->
