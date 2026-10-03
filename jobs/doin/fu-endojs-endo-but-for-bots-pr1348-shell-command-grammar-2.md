---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo endojs/endo-but-for-bots (PR https://github.com/endojs/endo-but-for-bots/pull/1348): `makeWorkspaceTools({ readOnly: true, shell })` still silently accepts both flags together (prior review note); fix it to reject or otherwise disallow combining `readOnly` with `shell`.

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-03T05:09:58Z
