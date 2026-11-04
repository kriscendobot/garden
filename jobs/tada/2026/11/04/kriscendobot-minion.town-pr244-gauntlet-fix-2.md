Fix round 2 for PR #244 is pushed and CI is green (7 of 7 checks, 0 failed). I fixed most of the panel-2 must-fix items; one breaker item (the replace retry) is only partly covered and is listed under follow-ups.

**Code changes** (commit `e66e75a2` on `feat/api-key-agent-ui`, pushed with `safe-push-pr-head.sh` on top of `d1587e92`):
- **Agents counted twice (breaker 1):** registry entries name a factory agent by its grant, and the code only matched them by `agentId`. `AgentSummary` now has an optional `grantId`, and `withAttachedAgents` drops a registry entry when either its `agentId` or its `grantId` belongs to a factory agent. Each agent now counts once on the provider card and in the replace's `remainingAgents`. The test fake now reports `grant-<name>`, and a new test covers a registry entry that names the agent only by its grant.
- **Bad limit values (breaker 3):** `agentLimits` now refuses negative and zero caps, and fractional values for every cap except `dailyDollars`. A new test covers -1, 0 and 0.5.
- **Stray comment (breaker 7):** the "Derive one reattachment's key" comment is back above `reattachKey`.
- **Repeated comment text (pruner 4):** I removed the module-comment sentence that repeated the error mapping in `inference-provider-service.ts`.

**PR body (pruner 1–3):** I cut the third mention of the flag in "What", the "Off, no agent route exists…" sentence, and "Nothing decides the parent design's open questions."

**Checks:** the three endpoint/service test files pass locally (65 tests) and `tsc --noEmit` is clean. During CI, the `changes` job's check stayed "in_progress" even though GitHub showed it as succeeded. I re-ran just that job, and `ci-wait-merge` then returned rc 0.

**Follow-ups:**
- **Replace retry (breaker 2), only partly addressed.** The server already uses stable per-move keys, so re-running a replace with the same `operationId` converges. But when some agents fail to move, the UI closes the dialog and a later attempt starts with new ids, so it never repeats the failed moves. A small UI follow-up would add a "retry moves" option that reuses `reattachOperationId`.
- **Factory must report `grantId`.** The double-count fix only works once the Endo agent factory reports each agent's grant; until then the count is still inflated.
- **Formatting.** Prettier reports pre-existing style differences in these files. The repo has no prettier gate in `package.json`, so I left them alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr244-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2775462 cached reads)
- Output: 12895 tokens
- Cost: $1.4483844000000001
- Wall-clock: 2092s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
