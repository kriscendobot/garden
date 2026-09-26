Reworked PR #889 at `ff1380fe3` and rebased it onto current `llm`.

- Reframed the root as an always-present logical workspace tree that advances on edits.
- Removed branch/ref, stage, physical-worktree, commit-OID, polling, and upstream coupling from the public model.
- Introduced provider-owned `GitRootSource` semantics for virtual and native hierarchies.
- Synchronized `designs/README.md`.
- Confirmed the review had no inline comments.
- All five CI checks pass.
- Posted the completion summary and re-requested review from kriskowal.
- Follow-up: maintainer approval remains pending.

Self-improvement: rebase stale PR heads before running local verification so checks exercise the current base.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr889-review-a90146c0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1924s

<!-- garden-usage-end -->
