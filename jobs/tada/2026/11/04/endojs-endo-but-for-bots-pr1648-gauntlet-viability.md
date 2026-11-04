`viability=proceed`: PR #1648 is open, unmerged and draft, and may enter the gauntlet. I spent no clean, panel, fix, CI-wait or un-draft budget.

**Deciding question:** Is `packages/hosted-agent/src/agent-factory.js` still the live, undisplaced implementation of phase 4 of the maintainer-approved API-key agents design, with that design's need still standing?

**Answer:** Yes.

**Evidence:**
- **PR state:** the head is `a46a836e92`, one commit ahead of and zero behind its pinned base `feature/api-key-provider-adapters-0b8d24a`. GitHub reports it mergeable. It was opened 2026-11-04T08:35Z and has no comments or reviews yet.
- **Need still holds:**
  - kriskowal approved design PR #1543 at 2026-11-04T00:29Z with "Please conduct the design and build the implementation."
  - That approval produced `orchestrate-build-api-key-agents-20261104`, whose child `build-api-key-agents-p4-agent-factory` led to this PR.
  - The design names the agent factory as the single coordinator and lists it as step 4 of the build plan.
  - The last maintainer decisions on tracker minion.town#227 (2026-11-03) extend this path and do not reverse it. The Phase 6 canary key is already provisioned, and endowments are a step in the guest-creation dialog.
- **Not superseded on the base:** `agent-factory.js` is not on `llm`, and neither is the registry it depends on. A title and content search of the repo finds no other implementation of this API-key factory. The latest `llm` commits I sampled are dependency bumps and test fixes.
- **Stack is current:** the base's pinned hash `0b8d24a114` still equals the head of #1575. #1575 is open and approved by kriskowal, and #1573 and #1543 are also open. Companion PR minion.town#244 is an open draft, updated at the same time as this PR.
- **Nearest competitor is not a replacement:** the `exo-agent-factory` stack (#1558, #1560–#1564, #1625–#1628) predates the approval and is all unmerged. Its design is a provider- and harness-neutral factory for child agents, authorized by held capabilities. #1648 is the root-private factory that creates owner-facing Lal/Fae guests attached to a provider, and kriskowal has no review or comment on #1558. Neither #1543's design nor #1648 treats the two as replacing each other.

**For later stages (none of this blocks viability):**
- **CI:** the rollup shows 3 failures, 16 successes and 17 skipped. I did not triage the failures, which belong to the gauntlet's CI stage.
- **Stack order:** #1648 sits on #1575, which sits on #1573, so #1573 and #1575 must land first.
- **Stale parked job:** `claude-api-p4-agent-factory` is still parked in `plan/` from the earlier 2026-10-27 orchestration and restates this phase. If promoted it would duplicate this work, so it needs retiring rather than building.
- **Coordination gap:** the design does not mention how its factory relates to `exo-agent-factory`. Someone may want to reconcile the two after both stacks land, but that does not affect this gate.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1648-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (234062 cached reads)
- Output: 5022 tokens
- Cost: $0.5924204000000001
- Wall-clock: 135s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
