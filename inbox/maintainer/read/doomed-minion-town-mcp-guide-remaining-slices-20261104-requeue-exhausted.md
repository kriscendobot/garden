from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T17:44:15Z
doom_base: minion-town-mcp-guide-remaining-slices-20261104
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T17:44:15Z
last_seen: 2026-11-05T17:44:15Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/minion-town-mcp-guide-remaining-slices-20261104; it stays HELD until a human promotes it
(promote-plan.sh minion-town-mcp-guide-remaining-slices-20261104) or removes it, so nothing is lost.
Original job base: minion-town-mcp-guide-remaining-slices-20261104

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-11-04T00:15:30Z
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-05T17:02:33Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finish the MCP guide's remaining slices (kriscendobot/minion.town#235)

Repo: kriscendobot/minion.town. PR: https://github.com/kriscendobot/minion.town/pull/235
(draft, held by `Disposition: orchestrated-slice`). Design:
`designs/mcp-resources-getting-started.md` § 8, on that PR's head branch.

#235 built slice 3. This job owns everything still open in its phase ledger. Merging
#235 deploys, and the design's stop gate forbids that before slice 2's baseline exists,
so the order matters:

1. **Slice 1, the rest.** Run the § 3.3 CapTP session to a clip's origin. Re-run
   `tools/guide-recipes/verify-production.ts` with `MINION_MCP_PREDEPLOY=1`: the
   recipes changed after the 2026-11-03 production run (accept now reads the locator
   from a bound file, and cleanup touches only the run's own mail).
2. **Slice 2.** The cold-agent harness and the § 6.1 preflight, then the baseline
   against production, before any resource ships. § 9 question 1 (which principal) is
   open: ask the maintainer before spending on the baseline.
3. Update #235's ledger with that evidence, including whether #235 may now merge.
4. **Slices 4, 5, 6.** Decompose into an orchestration if they do not fit one job.
   Slice 5 (treatment) follows the deploy, and slice 6 lands on the garden's trunk.

When the evidence is complete, turn #235's ledger to `deliverable`, so its completion
re-stages a fresh gauntlet.
