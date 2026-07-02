# shepherd on endojs/endo-but-for-bots PR #590 (llm lint-ceiling resume — re-post after churn)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only, no upstream endojs/endo touch). Standing comment auth applies.

PR #590 (base llm) was blocked by the typescript-eslint projectService lint ceiling; the llm branch now carries the bucketed scripts/eslint-repo.sh fix (#597, merged 2b2e3200). Rebase onto current origin/llm and drive CI green; re-fetch live state first (no-op if merged/closed). Escalate to a fixer only for a genuinely different failure. Prior run poisoned by fleet-restart churn during a host-identity fix, not a real handler failure; fleet now stable.

---
claim:
  host: endolinbot
  gardener: 90
  claimed_at: 2026-07-02T14:37:36Z
