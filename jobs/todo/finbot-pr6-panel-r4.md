---
role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-01T19:46:05Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
blocked_on: finbot-pr6-fix-panel-r3
---

# Run the required merge-governance panel for kriscendobot/finbot PR #6 (round 4, post-fix-r3 head)

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` — review the CURRENT branch tip (the head that
`finbot-pr6-fix-panel-r3` pushes; do not pin the stale `76bffd4`).
Base: `origin/main`.

**Why this job exists.** The round-3 panel (`finbot-pr6-panel-r3`) returned must-fix with
verified fail-open findings (inherited `dataSufficiencyMinCoverage` disarming the gate; raw
`proposal.steps` reads throwing out of `audit()`; the `windowTicks:0` gate-off regression; a
non-load-bearing `fitWindowTicks` off-gate test; a shallow-frozen `selection`/`model` leaf;
provenance-prose over-claim; and undocumented `config-integrity` / inverted `roles/auditor`
prose). `finbot-pr6-fix-panel-r3` (fixer) addresses them and pushes a new head; this job
re-runs the full panel at that head. This continues the panel→fixer loop until a clean panel.

## Do

1. Get an isolated project worktree for the PR head (keyed by YOUR job base, not the PR):
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/forecast-data-sufficiency`
2. Run the scripted code panel against `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 6 origin/main`
   Require a non-empty formal verdict from EVERY seat; retry any missing/empty seat (do not
   treat an empty block as a pass).
3. On must-fix findings, post a follow-on fixer job `finbot-pr6-fix-panel-r4` (role: fixer,
   tier: mentor, fallback minion, handler-timeout: 7200) carrying the current round's must-fix
   list, and a further panel re-run `finbot-pr6-panel-r5` blocked_on it — continuing the loop.
   Keep the tree green (CI `test` green, mergeable/CLEAN). Verify in particular that the
   round-3 fixes genuinely hold: the inherited-knob arming now fails closed via `readConfigKnob`;
   every `proposal.steps` read is snapshotted and never throws out of `audit()`; the
   `windowTicks:0`/`fitWindowTicks` gate-off path is byte-identical to `origin/main`; the
   `selection`/`model` leaf cannot be a mutable object in the hashed artifact; and the
   provenance residual is disclosed, not over-claimed as closed.
4. On a PASSING panel, leave the PR DRAFT — do NOT merge or un-draft. Post the sign-off job
   `finbot-pr6-signoff` with `role: orchestrator`, `tier: mentor`, and **NO model pin** (per
   the liaison's 2026-08-01 governance annotation removing the earlier `claude-fable-5` pin;
   confirmed by the plain-orchestrator sign-off that landed PR #4). Include the panel outcome
   and PR URL in that job's body. The orchestrator owns sign-off and any merge it directs —
   the builder/press NEVER merges.

Per merge governance (2026-07-22, amended 2026-08-01), this increment lands only after BOTH a
passing panel and an orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 1 -->
