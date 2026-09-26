Implemented and pushed commit `ede7f1f467` to `main2`.

- Reproduced the false-success against the real `journal2` artifact: previously classified `done`, now classified `failed`.
- Added anchored detection for frontmatter and dedicated Markdown-decorated verdict lines while rejecting prose mentions.
- Added an exact failure signal that `complete-job.sh --orchestration-failed` mechanically converts into frontmatter.
- Updated orchestration, job-board, post-plan, worker, and orchestrator guidance.
- Replaced blanket “All children succeeded” output with scoped per-child dispositions.
- Added regression coverage for the incident text, frontmatter, prose mentions, decoration, mechanical stamping, and completion summaries.
- Verification passed: full suite 368/368, orchestration 35/35, completion signal 20/20, gardener worktree 44/44.
- Follow-up: deploy the garden before this fix is live on the fleet.

Self-improvement: `skills/orchestration/SKILL.md`, `roles/orchestrator/AGENT.md`; encoded the mechanically stamped failure-verdict contract.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-orchestrate-child-failure-detection.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 636s

<!-- garden-usage-end -->
