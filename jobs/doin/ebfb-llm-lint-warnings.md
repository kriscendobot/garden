---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
branch: llm
role: cleaner
Address every lint warning currently emitted on the llm branch. Start from the latest origin/llm in an isolated worktree, discover and run the repository canonical lint commands rather than guessing, capture the complete warning inventory, and fix root causes across all affected packages. Do not silence warnings with blanket disables, weaken lint configuration, or introduce unrelated formatting churn; use narrow suppressions only where the warning is intentionally unavoidable and document each one. Preserve behavior, commit explicit pathspecs, rebase/CAS before pushing back to llm, and rerun the full canonical lint surface until it exits clean with zero warnings. Also run proportionate affected tests and report the exact commands, before/after warning counts, files changed, and any warning that cannot safely be eliminated rather than claiming success.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: mystic
  tier: 
  provider: moonshot
  model: 
  claimed_at: 2026-07-29T23:32:38Z
