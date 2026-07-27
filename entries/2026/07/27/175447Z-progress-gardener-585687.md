---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-27T17:54:48Z
---
# SturdyRef press tick (endo-sturdyref-press-20260727-175002) — HOLDING: go-ahead still pending at ~18h, zero drift, escalation due next tick

Watch tick, no code pushed. State re-verified 2026-07-27T17:5xZ (`gh pr view … --json …`):

- endojs/endo-but-for-bots#871 (agent provide/accept surface, Bar 2): OPEN draft, head unchanged at
  `c3fa894c9`, **21/21 SUCCESS**, zero reviews, zero comments. The panel has still never run.
- Bridge-cut stack (Bar 1) unchanged: #698 (head `build/sturdyref-bridge-1-bytes-wire-read`, base
  `build/sturdyrefs-endor-syscall-retention`), #700, #541 all OPEN drafts on unchanged bases, last
  touched 2026-07-25.
- The auto-gauntlet job `endo-sturdyref-agent-surface-build-gauntlet` remains parked in `jobs/plan/`
  with `gate: go-ahead`, poison record intact (deadline-overrun ×1), and the amended
  `handler-timeout: 14000`. The maintainer go-ahead requested 2026-07-26T23:42:09Z has not arrived
  (~18.2h elapsed); my job inbox is empty. Go-ahead promotion is maintainer-only — not self-promoting.
- No competing sturdyref worker in `jobs/doin/` or on the bus this tick.

Confinement properties stand as last exercised on the green heads (no push this tick): **no-location**
(passStyleOf-opaque sturdyref; enliven mediated by the closely-held OCapN network capability, design #539),
**no-identification** (unlinkable per-guest mints), **opaque-and-unforgeable**; #871 carries the
agent-surface guard/escrow regression tests, green in the 21/21 rollup cited above. Bars reported on CI
evidence; nothing re-run locally because nothing changed.

Next tick (~23:50Z) crosses the ~24h escalation threshold (2026-07-26T23:42Z + 24h ≈ 23:42Z): if the
gauntlet is still parked with no maintainer reply, escalate ONCE via message-user with a consolidated
note that the entire finish line is gated on this single promotion. If the gauntlet has left
`jobs/plan/`, watch it — do not collide. After clean panel + un-draft, resolve whether design #695
phase 4 (cross-turn retention/revocation) is in or out of the "throughout" bar.
