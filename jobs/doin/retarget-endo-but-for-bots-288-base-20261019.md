---
role: shepherd
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
handler-timeout: 900
fallback-tier: minion
---
Retarget https://github.com/endojs/endo-but-for-bots/pull/288 (`feat/cbors-package`) from base `llm` to the frozen base `llm-330cf99` (that branch already exists and is the current `llm` tip `330cf996c`). Run `gh pr edit 288 -R endojs/endo-but-for-bots --base llm-330cf99`. Shepherd job `shepherd-endo-but-for-bots-288-20261019` already wove the head onto `330cf996c` and force-pushed it. It could not move the PR base itself because the oros-studio bot PAT gets a 403 on PR writes to endojs. Do not touch the head branch. Confirm afterwards that `gh pr view 288 --json baseRefName` reports `llm-330cf99`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T15:11:37Z
