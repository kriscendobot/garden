---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-27T11:40:15Z
---
# SturdyRef press tick (endo-sturdyref-press-20260727-113510) — HOLDING: still blocked on maintainer go-ahead, zero drift, ~12h elapsed

Watch tick, no code pushed. State re-verified 2026-07-27T11:4xZ (`gh pr view … --json statusCheckRollup`):

- endojs/endo-but-for-bots#871 (agent provide/accept surface, Bar 2): OPEN draft, head unchanged at
  `c3fa894c9`, **21/21 SUCCESS**, zero reviews, zero comments. The panel has still never run.
- Bridge-cut stack (Bar 1) unchanged and mergeable: #698 re-verified **24/24 SUCCESS** this tick
  (base `build/sturdyrefs-endor-syscall-retention`), #700, #541, designs #511/#539 all OPEN drafts
  on unchanged bases.
- The auto-gauntlet job `endo-sturdyref-agent-surface-build-gauntlet` is STILL parked in `jobs/plan/`
  with `gate: go-ahead` and the amended `handler-timeout: 14000` intact. The maintainer go-ahead
  requested 2026-07-26T23:42:09Z has not arrived (~12h elapsed); my job inbox is empty. Per
  promote-plan.sh, go-ahead promotion is maintainer-only — not self-promoting, not re-messaging yet
  (the recorded escalation threshold is ~24h, i.e. ~2026-07-26T23:42Z + 24h ≈ tonight's ~23:35Z tick).
- No competing sturdyref worker in `jobs/doin/` or on the bus this tick.

Confinement properties stand as last exercised on the green heads (no push this tick): **no-location**
(passStyleOf-opaque sturdyref; enliven mediated by the closely-held OCapN network capability, design #539),
**no-identification** (unlinkable per-guest mints), **opaque-and-unforgeable**; #871 carries the
agent-surface guard/escrow regression tests, green in the 21/21 rollup cited above. Bars are reported
on CI evidence this tick; nothing was re-run locally because nothing changed.

Next tick: (1) if the gauntlet left `jobs/plan/`, watch it — do not collide; (2) the ~23:35Z tick
crosses the ~24h threshold — if still parked with no maintainer reply, escalate ONCE with a
consolidated message-user noting the entire finish line is gated on this single promotion;
(3) after clean panel + un-draft, resolve whether design #695 phase 4 (cross-turn
retention/revocation) is in or out of the "throughout" bar.
