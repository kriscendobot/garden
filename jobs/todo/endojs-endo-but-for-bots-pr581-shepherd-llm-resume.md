# shepherd on endojs/endo-but-for-bots PR #581 (llm lint-ceiling resume — re-post after churn)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only, no upstream endojs/endo touch). Standing comment auth applies.

PR #581 (base llm) was blocked by the typescript-eslint projectService lint ceiling; the llm branch now carries the bucketed scripts/eslint-repo.sh fix (#597, merged 2026-07-02 as 2b2e3200). Rebase #581 onto current origin/llm and drive CI to green; lint should now pass. Re-fetch live PR state first (fast no-op if since merged/closed). Escalate to a fixer only for a genuinely different, out-of-shepherd-scope failure.

NOTE: this job's prior run was poisoned by fleet-restart churn during a host-identity fix, NOT a real handler failure. The fleet is now stable (endolinbot leader). Re-posted by the liaison.

<!-- garden-reaped: 1 -->
