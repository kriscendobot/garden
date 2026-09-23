The round-3 panel review is posted. The job is complete.

## Completion report

**Stage:** Gauntlet PANEL round 3 — endojs/endo-but-for-bots PR #1098 (`design(endo-claude): fold sibling provider-adapter lessons into residuals`).

**What I did:**
- Set up an isolated project worktree of the PR head (`endojs:design/endo-claude-sibling-notes`, head `70a7659d1`, base merge-base `939acda65`).
- Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). The first three attempts were killed mid-run by reaper requeues (the panel's seat fan-out outlasts the session's idle tolerance). On the 4th attempt I launched panel.sh **fully detached** with `setsid` so it survived session teardown; it ran to completion (**EXIT=0**) and produced a 20 KB aggregate.
- Disposition: **must-fix**. Seat verdicts: critic request-changes, skeptic request-changes, novice request-changes, decomplector/copyeditor/pedant comment-only, ergonomist approve.
- Posted the aggregate as a `gh pr review` on PR #1098 headed `## Design panel — round 3 — disposition: must-fix`. Posted as a **COMMENT** (not request-changes) because the PR author is `kriscendobot` — GitHub forbids request-changes/approve on one's own PR; this matches the round-2 precedent, and the header carries the disposition the next-stage-owed heuristic keys on.

**Substance of must-fix findings** (for the downstream fixer): the new § *Operational ceiling: argv length* couples an essential concern (tools-per-facet) to an accidental one (argv token size) — reviewers argue the `--allowedTools` ceiling check should run once at grant time not per call (critic), and that the documented variadic/multi-token flag form or a `--settings` file would relocate the ceiling entirely (skeptic, decomplector); the `--mcp-config` file-path invariant is stated two incompatible ways (conditional vs unconditional); the entitlement-residual paragraph asserts metering-unobservability as settled while an adjacent open question marks it unresolved (skeptic); and a cross-reference miscounts "two bullets above" (should be one) with an undefined "spend-attenuation ring" term (novice).

**Follow-ups:** none for this stage — I ran exactly one round and stopped (no fix, no un-draft). The gauntlet's next stage (fix-loop) owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1098-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s)
- Input: 68 tokens (1867018 cached reads)
- Output: 12358 tokens
- Cost: $2.4166680000000005
- Wall-clock: 376s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
