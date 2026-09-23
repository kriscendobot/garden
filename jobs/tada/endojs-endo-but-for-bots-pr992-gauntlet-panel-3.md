Panel round 3 complete.

## Completion report

**Stage:** PANEL round 3 — endojs/endo-but-for-bots PR #992 (`design(http): HTTP client/controller as a metered pass-style adapter pipeline`)

**What I did:**
1. Resolved the PR head as `kriscendobot/endo-but-for-bots@design-http-adapter-pipeline` (a fork PR) and checked it out into an isolated per-job worktree.
2. Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 992 llm`. The panel process survived two reaper requeues/teardowns and ran to completion (28 seats). Terminal line: `panel #992: code-panel single-round — must-fix`.
3. Assembled a 40KB review body (under GitHub's limit; full 82KB aggregate retained in the run dir) and posted it as a **COMMENTED** `gh pr review` on PR #992 (GitHub disallows request-changes on one's own PR — same shape as rounds 1 & 2).

**Disposition:** must-fix — 12 seats requested changes (archivist, assessor, breaker, corner-prober, integrator, migrator, purist, saboteur, scribe, spec-keeper, stylist, typist), 7 commented, 9 approved.

**Key must-fix themes:** circuit-breaker half-open transition specified three inconsistent ways; outbound-body truncation silently corrupts caller-authored data (should reject, not truncate); `ctx`→`context` and `cost_max`/`cost_actual` snake_case naming drift; `@endo/cbor` typedefs living inline in a cross-referenced implementation file.

**Follow-ups:** none from this stage — I ran exactly one panel round, posted the verdict, and stopped (no fix / un-draft). The gauntlet's next stage owns the fix-loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 71 tokens (2272321 cached reads)
- Output: 14042 tokens
- Cost: $2.1800175
- Wall-clock: 375s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
