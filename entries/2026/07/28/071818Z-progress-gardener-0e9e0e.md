---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:18:24Z
---
# SturdyRef press tick (endo-sturdyref-press-20260728-004711) — HOLDING; overdue once-escalation SENT at 07:17Z

No code pushed. State re-verified live 2026-07-28T07:1xZ (`gh pr view … --json …`):

- endojs/endo-but-for-bots#871 (agent provide/accept surface, bar 2): OPEN draft, head unchanged at
  `c3fa894c9`, statusCheckRollup **21/21 SUCCESS**, zero reviews, zero comments. The panel has still
  never run.
- Bridge-cut stack (bar 1) unchanged: endojs/endo-but-for-bots#698 (`c19fdd96c`),
  endojs/endo-but-for-bots#700 (`e0122dfd7`), endojs/endo-but-for-bots#541 (`fd60a74b0`) — all OPEN
  drafts on unchanged bases, no motion since 2026-07-25.
- `endo-sturdyref-agent-surface-build-gauntlet` still parked in `jobs/plan/` with `gate: go-ahead`,
  poison record and amended `handler-timeout: 14000` intact.

**Escalation:** the go-ahead request of 2026-07-26T23:42Z was still UNREAD at ~31.6h. The planned
24h once-escalation never fired because the 20260728-004711 ticks crashed twice on ps23 (rc=1 at
00:49Z and 04:54Z, see the error entries). This tick SENT it: maintainer inbox
`20260728T071714Z-2cdc32`, asking for exactly one act — "go ahead on
endo-sturdyref-agent-surface-build-gauntlet". Future ticks: do NOT re-escalate; the once-escalation
is done. If the go-ahead arrives, the gauntlet job leaves `jobs/plan/` — watch it, don't collide.

**Peer coordination:** endo-sturdyref-press-20260728-065010 (ps23 gardener-1, claimed 06:51Z) was
live concurrently; notified via its inbox (`20260728T071752Z-337397`) that the escalation is sent
and nothing else is pressable this tick.

Confinement properties stand as last exercised on the green heads (no push this tick):
**no-location** (passStyleOf-opaque sturdyref; enliven mediated by the closely-held OCapN network
capability, design endojs/endo-but-for-bots#539), **no-identification** (unlinkable per-guest
mints), **opaque-and-unforgeable**; endojs/endo-but-for-bots#871 carries the agent-surface
guard/escrow regression tests, green inside the 21/21 rollup. Bars reported on CI evidence; nothing
re-run locally because nothing changed.

Next tick: if the gauntlet has left `jobs/plan/`, watch it to completion (clean is done; budget goes
to the panel); after clean panel + un-draft, resolve whether design endojs/endo-but-for-bots#695
phase 4 (cross-turn retention/revocation) is in or out of the "throughout" bar. If still parked, hold
— escalation already sent; surface again only on maintainer request or ~72h total silence.
