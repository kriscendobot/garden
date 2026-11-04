**PR #238 viability: proceed.** It is an open draft at head `d94936ff`. Its base `main-9196892` matches current `main` (0 ahead, 0 behind). I changed nothing.

Deciding question: Does anything newer than #238 now specify the budgeted spawner, endowments and git-VFS tool bundle for API-key agents, or has the maintainer dropped the need for them? No to both, so the gauntlet may begin.

Evidence:
- **Not superseded by a move:** the maintainer asked on 2026-11-04 for the design to move out of Endo because it "does not describe a work product on Endo". #238 is the result of that move, so it is the current home of the design. It isn't being replaced.
- **Nothing built:** `AgentSpawner`, `SubagentControl`, `DelegationControl`, `grant-workbench` and `workbench` have no code-search hits in minion.town. Endo's `llm` branch has no `workbench`, `api-key`, `spawner`, `budget` or `endow` design file, and no matching `AgentSpawner` or `DelegationControl` file. Its only name match is Fae's existing `packages/fae/subagent-spawner.js`, which the design reuses. No other open PR on either repo covers this scope.
- **Need still holds:**
    - The maintainer approved the provider design endojs/endo-but-for-bots#1543 on 2026-11-04 ("conduct the design and build the implementation"). Its current text still says the spawner is "specified and built under the agent workbench design".
    - Tracker #227 still lists the workbench as a live ask, and its 2026-11-03 decisions make endowments a step in the guest-creation dialog, including guests with pinned AI.
    - Companion PR #228 still depends on #238, and plan `build-claude-api-agent-workbench-20261027` is parked waiting on it.
- **Closest rival doesn't displace it:** endojs/endo-but-for-bots#1558, with builds #1560 and #1562, is a generic child-agent factory.
    - It is unmerged, and it predates this design by a day.
    - It has no token-budget attenuation or pause and resize controls, and no tool bundle.
    - It calls #1543 a downstream consumer, while #1543 assigns the spawner to the workbench design.

Points for the panel and the maintainer (none of these block):
- **Unreferenced overlap:** #238 never mentions #1558 or `@endo/exo-agent-factory`, even though both define a child-agent creation path, and its prompt says not to invent parallel mechanisms. A reviewer should settle how the two relate, because the factory's recursive spawner is a real candidate for what the budgeted spawner builds on. #1558 could also become a reason to reshape the design if the maintainer takes it up.
- **Stale open question:** question 5 is partly answered by the 2026-11-03 endowments decision, but the design still lists it as open.
- **Other open questions:** the design says questions 3 and 6 must be answered before it can be accepted, and question 7 gates the W1-W5 build. A clean gauntlet still leaves it waiting on the maintainer.
- **Stale records:**
    - The tracker's review table (row 5) still points to #1574 and says six questions, not seven.
    - The plan annotation says #1574 is closed, but it is still open with a close job queued.
    - #1543's head has moved past `069b429c16`, the commit this design pins and is grounded against.
- **Not checked:** CI status on #238, because the bot PAT can't read the check rollup. Viability doesn't depend on it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr238-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (328995 cached reads)
- Output: 6755 tokens
- Cost: $0.7423949999999999
- Wall-clock: 264s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
