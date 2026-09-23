---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-18T16:37:01Z
---
# SturdyRef press — 16:35 dispatch tick (no movement; nudge held, re-send due ~20:07Z)

Observation-only tick. Verified live (~16:40Z, 2026-07-18) that nothing has
moved since the 14:36 tick
(`entries/2026/07/18/143638Z-progress-gardener-06967e.md`).

**Verified live (`gh pr view --json state,updatedAt,headRefOid,reviewDecision`):**
- endojs/endo-but-for-bots#737 updated 2026-07-17T06:19:35Z, CHANGES_REQUESTED,
  head b56b346534; #774 05:11:07Z, no review, head 59bd235e2b; #695 07-15
  CHANGES_REQUESTED (f5df0a4c83); #697 07-15 CHANGES_REQUESTED (e4a0a614b8);
  #539 07-11 CHANGES_REQUESTED (22923949b2); #698 (4e21536286) / #700
  (951cde7f13) / #541 (fab626e84a) all 07-11, OPEN drafts; #511 (182d0449eb)
  06-26. Every timestamp and head identical to the 14:36 tick — no pushes,
  reviews, or comments since 2026-07-17T06:19Z.
- The consolidated maintainer nudge (`inbox/maintainer/unread/20260717T200708Z-5cde04.md`)
  is still unread, ~20.5h old — inside the 24h re-send window (next re-send due
  ~2026-07-18T20:07Z). Held per the standing norm; no re-send this tick.
- No peer sturdyref job live (`inbox-list.sh`: xs2rust presses, esheets
  supervisor, self-heal agents, liaison); `jobs/doin/` holds the npm-cas-registry
  press and an xs2rust stage-10 job; my inbox empty.
- CI not re-run this tick: branch heads unmoved since the 07-17 11:36Z green
  verification — a re-check would observe the same commits; not re-verified.

**Action taken:** none beyond verification — every lane remains gated on the
same maintainer decisions: the shim-placement arbitration (#737 embedded vs
#774 standalone `@endo/sturdyref`), the rank-prefix + stack-collapse picks,
and the design re-reviews (#695/#697/#539, fleet-side responses already
posted). Pushing code before arbitration would churn the single-commit review
shapes under maintainer review.

**Confinement:** no sturdyref behavior changed this tick; the invariants
continue to ride #774's four confinement tests (no-location,
no-identification/unlinkability, withheld-from-compartments, first-wins
convergence) and #737's pass-style opacity coverage, last verified green at
the current heads.

**Next driver:** the 18:35 tick is still inside the window; the first tick at
or past ~20:07Z re-sends the nudge if `20260717T200708Z-5cde04` is still
unread. On arbitration, converge #774/#737 on the chosen home before
restacking #698 → #700 → #541.
