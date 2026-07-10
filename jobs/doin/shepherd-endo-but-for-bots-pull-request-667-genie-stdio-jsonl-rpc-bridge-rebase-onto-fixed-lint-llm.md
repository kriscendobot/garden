---
role: shepherd
---

Shepherd `endojs/endo-but-for-bots` DRAFT PR #667 (`feat(genie): stdio JSONL RPC bridge`, endopi-stdio-rpc-bridge, M3): rebase it onto current `origin/llm` (HEAD `2b2e3200`, where the eslint projectService lint-ceiling fix from #596/#597 lives) and drive CI to green — the same resume treatment the lint-ceiling batch gave the other `llm`-based PRs but which #667 (built later) missed, leaving its sole red the now-fixed lint check. Use a distinct job identity; re-escalate to a fixer only for a genuinely different, out-of-scope red.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  claimed_at: 2026-07-10T12:56:41Z
