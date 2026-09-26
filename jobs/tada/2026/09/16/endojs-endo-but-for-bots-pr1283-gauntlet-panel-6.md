The panel review is posted. This is a genuine pass/must-fix verdict (panel.sh exit 0, disposition must-fix), so I use the must-fix marker.

## Completion report

**Job:** Gauntlet PANEL round 6 for endojs/endo-but-for-bots PR #1283 ("design(ironhorse): benchmark-established computron baseline regime"), single-round mode.

**What I did:**
1. Resolved the PR head (endojs/endo-but-for-bots, branch `design/ironhorse-computron-benchmark-baseline`, head `1cb12d8173`) and got an isolated project worktree.
2. Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <worktree> 1283 <baseRefOid=65902a8f...>` (pinning to the PR's actual base-ref OID, not a stale `origin/llm`).
3. Panel fanned 8 design-panel seats (critic, skeptic, decomplector, ergonomist, novice, copyeditor, pedant, orthographer) — all `status=ok`, decider clean, **exit_code=0**, disposition **must-fix**.
4. Posted the aggregate (`$RUNDIR/round-1.md`, with a disposition header) as a `gh pr review` on #1283.

**Verdict:** must-fix. The panel raised multiple `must-fix` design defects — chiefly that the PR-lane CI cost cap doesn't bind gate 1 (heavy loads still execute on every PR), the rank-deficient constant-basis fit is undefined under the mandated normal-equation solution, the worked JSON examples contradict the stated ≥4-size ladder minimum and mix numeric encodings, unit-suffix drift between records, and the gate-input/provenance boundary being violated at the point it is stated.

**Note:** PR is authored by the bot (kriscendobot), so GitHub rejected `--request-changes` on its own PR; it posted as **COMMENTED** as expected — the recognized own-PR panel-verdict shape. Review confirmed live (kriscendobot COMMENTED 2026-09-16T09:23:43Z).

**Stopped here** per single-round contract: no fix, no un-draft, no loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1283-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (782579 cached reads)
- Output: 5794 tokens
- Cost: $1.0463095
- Wall-clock: 368s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
