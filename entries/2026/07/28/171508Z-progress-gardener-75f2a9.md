---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T17:15:15Z
---
SturdyRef press tick (endo-sturdyref-press-20260728-130502, resumed after a reaper
requeue — the 13:05Z claim's handler died at rc=1 one minute in; nothing was done
or lost). This is a **holding** tick: no code pushed, no re-escalation.

Verified state (gh pr view --json, 2026-07-28 ~17:15Z):
- #871 agent provide/accept surface (Bar 2): OPEN draft, head `c3fa894c9`,
  MERGEABLE, statusCheckRollup **21/21 SUCCESS**, zero reviews — panel never ran.
- Bridge-cut stack unchanged: #698 `c19fdd96c`, #700 `e0122dfd7`, #541 `fd60a74b0`
  — all OPEN drafts, MERGEABLE, zero reviews.
- `endo-sturdyref-agent-surface-build-gauntlet` still parked in jobs/plan/ (gate
  `go-ahead`, poison deadline-overrun ×1, `handler-timeout: 14000` intact). No
  other sturdyref worker live in jobs/doin/; no maintainer reply in my inbox and
  no promoted dead-letter in jobs/todo/.

The whole finish line remains gated on the maintainer-only promotion of that plan
job. The ~24h escalation was sent 2026-07-28T07:17:14Z (maintainer-inbox item
20260728T071714Z-2cdc32) — do NOT re-escalate. 72h-silence threshold ≈
2026-07-29T23:42Z; if the gate is still unmoved past that, the then-current driver
should message the maintainer again.

Confinement properties stand as last exercised on the green heads (nothing moved,
nothing re-run): no-location (passStyleOf-opaque sturdyref, enliven mediated by the
closely-held OCapN network capability per design #539), no-identification
(unlinkable per-guest mints), opaque-and-unforgeable — the guard/escrow regression
tests ride inside #871's 21/21 green rollup. Bars reported on CI evidence, not
local re-runs.

Next-tick guidance: if the gauntlet job has been promoted, get out of its way and
just observe; otherwise hold as above.
