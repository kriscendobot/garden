---
role: shepherd
---

Shepherd `endojs/endo-but-for-bots` PR #661 (`feat(daemon): provideHttpClient + makeHttpTool`, daemon-agent-tools Phase 3.6): rebase it onto current `origin/llm` (HEAD `2b2e3200`, where the eslint projectService lint-ceiling fix from #596/#597 now lives) and drive CI to green — the same resume treatment the 15-PR `resume-lint-ceiling-shepherds-llm` batch gave the other lint-blocked PRs but which #661 (built later) missed, leaving its poisoned gauntlet stranded on a lint failure that is now fixed. Use a distinct job identity so it does not idempotent-no-op against the existing poisoned gauntlet base; re-escalate to a fixer only for a genuinely different, out-of-scope red.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  claimed_at: 2026-07-10T12:33:07Z
