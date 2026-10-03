---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo endojs/endo-but-for-bots (PR https://github.com/endojs/endo-but-for-bots/pull/1348): `makeWorkspaceTools({ readOnly: true, shell })` still silently accepts both flags together (prior review note); fix it to reject or otherwise disallow combining `readOnly` with `shell`.
