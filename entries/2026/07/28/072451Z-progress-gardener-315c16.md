---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:24:54Z
---
# SturdyRef press tick (endo-sturdyref-press-20260728-065010) — HOLDING; escalation already sent by peer 004711, no double-send

Watch tick, no code pushed. The concurrent older instance (endo-sturdyref-press-20260728-004711)
sent the ~24h once-escalation to the maintainer at 2026-07-28T07:17:14Z (inbox item
`20260728T071714Z-2cdc32`) and messaged this job's inbox to prevent a double-send
(`20260728T071752Z-337397`, drained). Per that coordination and my own re-verification,
nothing else is pressable this tick.

State re-verified live 2026-07-28T07:2xZ (`gh pr view … --json …`):

- endojs/endo-but-for-bots#871 (agent provide/accept surface, Bar 2): OPEN draft, head unchanged at
  `c3fa894c9`, statusCheckRollup **21/21 SUCCESS**, zero reviews, zero comments. The panel has
  still never run.
- Bridge-cut stack (Bar 1) unchanged: endojs/endo-but-for-bots#698 (head `c19fdd96c`, base
  `build/sturdyrefs-endor-syscall-retention`), endojs/endo-but-for-bots#700 (head `e0122dfd7`),
  endojs/endo-but-for-bots#541 (head `fd60a74b0`) — all OPEN drafts, no motion since 2026-07-25.
- `endo-sturdyref-agent-surface-build-gauntlet` still parked in `jobs/plan/` with `gate: go-ahead`
  (poison record deadline-overrun ×1, amended `handler-timeout: 14000` intact). Promotion is
  maintainer-only; not self-promoting.
- No other live sturdyref worker in `jobs/doin/` this tick.

Confinement properties stand as last exercised on the green heads (no push this tick):
**no-location** (passStyleOf-opaque sturdyref; enliven mediated by the closely-held OCapN network
capability, design endojs/endo-but-for-bots#539), **no-identification** (unlinkable per-guest
mints), **opaque-and-unforgeable**; endojs/endo-but-for-bots#871 carries the agent-surface
guard/escrow regression tests, green inside the 21/21 rollup. Bars reported on CI evidence;
nothing re-run locally because nothing changed.

Next tick: do NOT re-escalate (once-escalation done 07:17Z). If the gauntlet has left
`jobs/plan/`, watch it to completion without colliding (clean is done; budget goes to the panel);
after clean panel + un-draft, resolve whether design endojs/endo-but-for-bots#695 phase 4
(cross-turn retention/revocation) is in or out of the "throughout" bar. If still parked, hold;
surface again only on maintainer request or ~72h total silence (threshold ≈ 2026-07-29T23:42Z).
