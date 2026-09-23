---
gate: go-ahead
priority: normal
parked_at: 2026-08-02T21:03:45Z
parked_by: liaison:endolin-garden-ece02cb4
parked_reason: maintainer directive — board cleared so the fleet runs
  ONLY the budget/cost-attribution orchestration. Restore with
  promote-plan.sh when that work concludes.
---

---
role: cleaner
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-30T16:15:30Z cleared=deadline-overrun=1 -->

---
tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
branch: llm
role: cleaner
Address every lint warning currently emitted on the llm branch. Start from the latest origin/llm in an isolated worktree, discover and run the repository canonical lint commands rather than guessing, capture the complete warning inventory, and fix root causes across all affected packages. Do not silence warnings with blanket disables, weaken lint configuration, or introduce unrelated formatting churn; use narrow suppressions only where the warning is intentionally unavoidable and document each one. Preserve behavior, commit explicit pathspecs, rebase/CAS before pushing back to llm, and rerun the full canonical lint surface until it exits clean with zero warnings. Also run proportionate affected tests and report the exact commands, before/after warning counts, files changed, and any warning that cannot safely be eliminated rather than claiming success.

<!-- garden-reaped: 1 -->
