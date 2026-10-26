**Gauntlet viability report for endojs/endo-but-for-bots PR #1563: proceed**

The PR is safe to enter the gauntlet. It hasn't been replaced, and the design that motivated it is still open and still asks for this work.

**PR facts:**
- State: OPEN, draft, not merged. Opened 2026-10-26T04:21Z by job `build-endo-exo-agent-factory-turn-ledger`.
- Head: `build/exo-agent-factory-turn-ledger` @ `1762c1be`.
- Base: frozen `build/exo-agent-factory-core-8c4a87e` @ `8c4a87e9`, which means it stacks on #1560.
- Scope: Phase 5 of `designs/endo-child-agent-factory.md` (design PR #1558). It adds a keyed turn ledger (`TurnStarted` / `TurnResult` / `Published`), replays a recorded result without running inference again, and republishes with the same `replyTo`. It also adds a worked example of a provider-backed agent and crash-cut tests.

Deciding question: Is Phase 5 of the child-agent-factory design still an open, un-implemented work item, with its design and parent stack still live?

Evidence:
- Design PR #1558 is OPEN, last updated 2026-10-26T01:51Z, with only bot COMMENTED reviews. Its text still specifies the `TurnStarted` / `TurnResult` / `Published` ledger, republishing with the same `replyTo`, and crash-cut acceptance tests.
- The parent PR #1560 (the coordinator core) is OPEN. The sibling slices #1561 (daemon wiring) and #1562 (topology and maker adapters) are OPEN and cover other phases.
- A search for "turn ledger" and "exo-agent-factory" PRs found nothing else that implements turn journaling or replay, so nothing has displaced this PR.
- The `exo-agent-factory` package has not shipped, so the premise still holds.
- One minor point for the panel: the design describes publishing through `send` with `replyToMessageNumber`. The PR body says it uses the daemon's `reply` operation with the existing wire `replyTo` field. The intent is the same, so this doesn't make the PR overtaken.

Follow-ups: none from this stage. Because the PR is stacked, it will need re-weaving when #1560 lands.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1563-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178688 cached reads)
- Output: 1809 tokens
- Cost: $0.43991759999999996
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
