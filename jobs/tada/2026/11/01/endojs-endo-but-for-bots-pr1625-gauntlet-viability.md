I checked PR #1625 before any review or fix spending, and it should go ahead: nothing has replaced it and the gap it fills is still open.

Deciding question: Does the current head of #1560 (`21d142af2d`), or any newer merged or open PR, already give the coordinator facet that durable facet formulas call (`boundFacet(namespaceId)` and `lifecycleFor(operationId)`, failing closed on ids it never issued)?

Answer: No.

Evidence:
- **PR state:** #1625 is OPEN, a draft and not merged. It was opened 2026-11-01T18:01Z, a minute before this check. Its base is `build/exo-agent-factory-core-21d142a`, which is exactly #1560's current head. It is one commit ahead of that base and none behind, and touches 4 files in `packages/exo-agent-factory`.
- **The gap is still there:** at `21d142af2d`, `coordinator.js` has only the in-memory `boundFacet` re-issue helper (line ~1085) and a private `lifecycleFor` closure. It has no `coordinatorFacet`, no public `lifecycleFor(operationId)`, no inert lifecycle for removed or revoked children, and no fail-closed refusal of unissued ids. The package is not on `llm` at all. The stack it builds on, #1558 (design) and #1560 (core), is open and unmerged.
- **Nothing newer replaces it:** the only overlapping work is the older draft #1561 (2026-10-26, last updated 10-29). It adds a similar `lifecycle(opKey)` accessor and the daemon-side `ChildAgentCoordinator` facet. But it sits on a stale core snapshot, `core-8c4a87e`, which is 7 commits behind the current #1560 head and lacks the 10-31 revocation and orphan fixes. #1625 is the newer version of the coordinator-side work, built on the current core head, and its description says the daemon slice will then be written against it. So #1625 does not duplicate a newer implementation.
- **The reason for it still holds:** design #1558 (§ Durable facets, § Recovery matrix) still has the coordinator facet as the only endowment of each durable facet formula. Panel reviews on #1558 raised must-fix points about revived lifecycles and reconciliation, which this PR's fail-closed restart path speaks to. The PR also leaves out a bespoke lease protocol, matching the design's § Rejected alternatives.

Follow-up for later stages: #1561 overlaps #1625 on the coordinator side. Once #1625 lands, #1561 should be rebuilt as the daemon slice on top of it rather than merged as it is, or it will conflict. #1625 also needs retargeting to `llm` after #1560 lands, as its description says.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1625-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (369417 cached reads)
- Output: 3705 tokens
- Cost: $0.5777994000000001
- Wall-clock: 56s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
