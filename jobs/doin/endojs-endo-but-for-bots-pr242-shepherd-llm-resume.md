# shepherd on endojs/endo-but-for-bots PR #242 (llm lint-ceiling resume)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only, no upstream endojs/endo touch).

PR #242 (base per its head) was blocked by the typescript-eslint project-service lint scaling
ceiling and its pre-fix shepherd escalated (the whole-repo `eslint .` run deterministically
dropped the alphabetically-last package). The `llm` branch now carries the bucketed
`scripts/eslint-repo.sh` fix (fresh PR #597, merged 2026-07-02 as commit `2b2e3200`;
`package.json` `lint:eslint` delegates to the script, which batches packages by
`ESLINT_BUCKET_SIZE` so no bucket exceeds the projectService ceiling).

Task: rebase PR #242 onto current `origin/llm` and drive CI to green. Its base is the frozen snapshot `llm-b1c3f4d`; unfreeze it to live `llm` as part of the rebase.
With the ceiling gone on `llm`, `lint` should now pass on rebase; handle any other still-red
check and re-escalate (to a fixer) only for a genuinely different, out-of-shepherd-scope failure.
Re-fetch live PR state first — the PR is a fast no-op if it has since merged or closed.

Standing external-repo etiquette applies (no comment unless the job carries comment authorization).

Provenance: `resume-lint-ceiling-shepherds-llm` (the llm half of the split lint-ceiling resume
directive, kriskowal 2026-07-02). Source fix: `ebfb-594-fresh-llm-pr-merge` (PR #597 on llm).

<!-- garden-reaped: 2 -->

<!-- garden-reap-now -->
---
claim:
  host: endolinbot2
  gardener: 87
  claimed_at: 2026-07-02T10:23:20Z
