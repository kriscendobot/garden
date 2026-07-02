# shepherd on endojs/endo-but-for-bots PR #320 (llm lint-ceiling resume — re-post after churn)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only, no upstream endojs/endo touch). Standing comment auth applies.

PR #320 (base llm) was blocked by the typescript-eslint projectService lint ceiling; the llm branch now carries the bucketed scripts/eslint-repo.sh fix (#597, merged 2026-07-02 as 2b2e3200). Rebase #320 onto current origin/llm and drive CI to green; lint should now pass. Re-fetch live PR state first (fast no-op if since merged/closed). Escalate to a fixer only for a genuinely different, out-of-shepherd-scope failure.

NOTE: this job's prior run was poisoned by fleet-restart churn during a host-identity fix, NOT a real handler failure. The fleet is now stable (endolinbot leader). Re-posted by the liaison.

<!-- garden-reap-now -->
---
claim:
  host: endolinbot
  gardener: 3
  claimed_at: 2026-07-02T14:35:11Z
