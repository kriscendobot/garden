The job is already complete. A prior (pre-reap) attempt posted the Demo 2 deliverable comment, and all referenced PR states are unchanged since 2026-09-23 (before the comment), so the posted verdict remains accurate. No re-work is needed or warranted.

## Completion report — `verify-demo2-cross-host-locator-instructions`

**Outcome: already done by a prior attempt; verified still accurate. No new changes needed.**

### What I found
This is a cross-host reaper requeue (claimed 14:46:25Z). A prior attempt of this job had already produced and **posted** the Demo 2 deliverable at **14:34:23Z** — before this re-claim — as a reply comment on issue #114 (issue not closed, matching the spec):

**Comment URL:** https://github.com/kriscendobot/garden/issues/114#issuecomment-5872132557

That comment fully satisfies the deliverable:
- **Leads with a one-line verdict:** *"Demo 2 verdict: works on a local two-daemon bench only; it cannot run in production yet."*
- **Both claims checked separately:** (1) the bench claim ("two real daemons, survives a restart") was re-run — tests `locator-adoption-ocapn` / `ocapn-endpoint-locator` / `networks-ocapn` at #1335's head, **18/18 pass**, plus a by-hand two-daemon CLI script on both #1333-alone and #1335 heads; (2) the production-on-minion.town claim is correctly reported **NOT YET runnable**, gated on #1335 (plus #1124/#1333 merge + minion.town#117 activation), with the gate not bypassed.
- **A precise reproducible bench runbook** with the real current CLI surface (`endo adopt-locator minion-town < loc`, `endo eval 'E(g).lookup("greeting")' g:minion-town`, restart-survival, tampered-locator rejection), verified against `packages/cli/src/endo.js`, clearly labeled bench vs. production.
- **Two rough edges surfaced** (failed-adopt breaks the good name until restart; hosting-daemon restart strands adopted laptops) — useful demo caveats.

### Verification that the posted verdict still holds (re-checked today, 2026-09-28)
| PR | State now | Last updated | Consistent with posted verdict? |
| --- | --- | --- | --- |
| endojs/endo-but-for-bots#1333 (`endo adopt-locator`) | draft, OPEN | 2026-09-23 | ✅ still draft/unreviewed |
| endojs/endo-but-for-bots#1335 (session-binding fix) | draft, OPEN, reviews: 0 | 2026-09-23 | ✅ still the blocker, unreviewed |
| endojs/endo-but-for-bots#1124 (nonce locator base) | draft, OPEN, not merged | 2026-09-23 | ✅ base still unmerged |
| kriscendobot/minion.town#117 (guest-locator reveal) | draft, "do not activate" | 2026-09-23 | ✅ not deployed/activated |

All four are unchanged since **2026-09-23**, i.e. before the comment was posted on **2026-09-28**, so the production gate remains closed and the "bench-verified only" verdict is current. No garden repo (main2) changes are involved in this job.

### Follow-ups
None required by this job. The demo's path to production remains gated on #1335 landing + `deploy-endo-federation.sh enable` (tracked on minion.town#117), and the two rough edges the runbook flagged were recommended for attaching to #1333/#1335 before activation — outside this verification job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/verify-demo2-cross-host-locator-instructions.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 104 tokens (4367336 cached reads)
- Output: 30230 tokens
- Cost: $2.945754299999999
- Wall-clock: 549s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
