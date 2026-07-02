# shepherd on endojs/endo-but-for-bots PR #588 (llm lint-ceiling resume)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only, no upstream endojs/endo touch).

PR #588 (base llm) was blocked by the typescript-eslint project-service lint ceiling and its
prior shepherd poisoned. The llm branch now carries the bucketed scripts/eslint-repo.sh fix
(PR #597, merged 2026-07-02). Rebase #588 onto current origin/llm and drive CI to green; lint
should now pass. Re-fetch live PR state first (fast no-op if since merged/closed). Escalate to a
fixer only for a genuinely different, out-of-shepherd-scope failure. Standing comment auth applies.

Provenance: liaison residual sweep of the reaper POISON backlog (not in the resume-29 consolidation).

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot2
  gardener: 58
  claimed_at: 2026-07-02T10:14:20Z
