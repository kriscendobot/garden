---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-28T23:29:23Z
---
SturdyRef press tick (endo-sturdyref-press-20260728-192002, ~23:45Z) — blocker unmoved; one hygiene act: closed the zombie duplicate PR #865.

State (all re-verified live via `gh pr view --json` ~23:40Z):
- Bar-2 canonical PR endojs/endo-but-for-bots#871 (agent provide/accept surface): OPEN draft, MERGEABLE, 21/21 statusCheckRollup SUCCESS, zero reviews. Head `c3fa894c9` unchanged.
- Full stack heads unchanged since 07-25: #774 `59bd235e2` / #737 `49ed6026a` / #541 `fd60a74b0` / #698 `c19fdd96c` / #700 `e0122dfd7` / #701 `a99012a62` / #702 `137673219` / #703 `bb3906aad` / #704 `e32b01f2a`. All OPEN drafts.
- Single blocker unchanged: `endo-sturdyref-agent-surface-build-gauntlet` still parked in `jobs/plan/` behind maintainer-only gate `go-ahead` (handler-timeout 14000 intact). Escalation sent 2026-07-28T07:17:14Z; 72h-silence re-escalation threshold ≈ 2026-07-29T23:42Z — NOT passed, so no message sent this tick.

Action this tick: closed endojs/endo-but-for-bots#865 as a duplicate (comment + close, branch left in place). Provenance: the `endo-sturdyref-agent-surface-build` job was claimed 4× (stranded incarnations reaped); an early stranded run opened #865 on the in-repo branch, the completed run opened #871 (fork head) and recorded it; the branches then diverged (fork 3 ahead / 5 behind), #865 failed all 4 test matrix legs and had already attracted one auto-shepherd today (minted + retired by the ci-watcher stale-sweep). Unattributed "fixup!" pushes landed on #865's branch this morning (06:59Z/07:15Z) from a stranded worker — likely a ps23 orphan (that host's claims were requeued today); no live job in `jobs/doin/` references it. Closing stops further auto-shepherd minting against a PR that will not land.

Confinement properties stand as last exercised on the green heads (no code changed this tick): no-location (passStyleOf-opaque sturdyref; enliven mediated by the closely-held OCapN network capability, design #539), no-identification (unlinkable per-guest mints), opaque-and-unforgeable — the guard/escrow regression tests ride inside #871's 21/21 rollup.

Next-tick guidance: watch for the gauntlet's promotion out of plan/ (then observe, don't collide); re-escalate to the maintainer ONLY after ≈2026-07-29T23:42Z; if new pushes appear on the closed #865's in-repo branch, a stranded worker may still be alive — investigate before touching that branch.
