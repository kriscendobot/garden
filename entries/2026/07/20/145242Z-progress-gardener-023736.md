---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-20T14:52:43Z
---
# SturdyRef press — 14:51 dispatch tick (no movement; holding; nudge window not yet open)

Tick action: hold + observation. Verified live (~14:55Z, 2026-07-20) that
nothing has moved since the 08:35 tick
(`entries/2026/07/20/083746Z-progress-gardener-094551.md`).

**Verified live (`gh pr view --json state,isDraft,updatedAt,headRefOid,reviewDecision`
against endojs/endo-but-for-bots, ~14:55Z):**
- #737 2026-07-17T06:19:35Z b56b3465 CHANGES_REQUESTED; #774 07-17T05:11Z
  59bd235e (no review); #695 07-15 f5df0a4c CHANGES_REQUESTED; #697 07-15
  e4a0a614 CHANGES_REQUESTED; #539 07-11 22923949 CHANGES_REQUESTED;
  #698 4e215362 / #700 951cde7f / #541 fab626e8 all 07-11 OPEN drafts;
  #511 06-26 182d0449. Every timestamp and head identical to the 08:35
  tick — ~80.5h of quiet since 2026-07-17T06:19Z.
- No peer sturdyref job live (`inbox-list.sh`: other presses — byte-array,
  daemon-data-plane, git-integration, npm-cas-registry, vfs-parity — plus
  xs2rust, self-heal agents, liaison); my inbox empty; `jobs/doin/` holds
  only the press jobs, no other sturdyref work.
- CI not re-run: branch heads unmoved since the 07-17 green verification
  ("not re-verified" by design — a re-check would observe the same
  commits).

**Action taken:** none beyond verification. The 02:29 consolidated
maintainer nudge (`inbox/maintainer/unread/20260720T022911Z-800ee8.md`)
is still unread (~12.5h old); its 24h re-send window opens
~2026-07-21T02:29Z, so no re-send this tick. Every lane remains gated on
the same maintainer decisions: shim-placement arbitration (#737 embedded
vs #774 standalone `@endo/sturdyref`), the rank-prefix + stack-collapse
picks, and the design re-reviews (#695/#697/#539, fleet responses
already posted). Pushing code ahead of the arbitration would risk
building on the losing home. Maintainer inbox backlog now 133 unread
(dating to 07-16), so the gate may persist; per the standing note, the
2026-07-21 ticks keep the re-send cadence rather than escalate.

**Confinement:** no sturdyref behavior changed this tick; the invariants
continue to ride #774's four confinement tests (no-location,
no-identification/unlinkability, withheld-from-compartments, first-wins
convergence) and #737's pass-style opacity coverage, last verified green
at the current heads.

**Next driver:** hold unless the maintainer answers or a head moves. On
arbitration, converge #774/#737 on the chosen home before restacking
#698 → #700 → #541. Next nudge re-send window opens ~2026-07-21T02:29Z
if `20260720T022911Z-800ee8` is still unread.
