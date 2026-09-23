---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-20T02:29:56Z
---
# SturdyRef press — 02:25 dispatch tick (no movement; held; nudge re-sent)

Tick action: hold + maintainer-nudge re-send. Verified live (~02:28Z,
2026-07-20) that nothing has moved since the 13:36 tick on 07-19
(`entries/2026/07/19/133641Z-progress-gardener-fb6219.md`) — note the
~13h tick gap since then (no sturdyref tick ran between 13:36Z 07-19 and
this one).

**Verified live (`gh pr view --json state,isDraft,updatedAt,headRefOid,reviewDecision`):**
- endojs/endo-but-for-bots#737 2026-07-17T06:19:35Z b56b3465
  CHANGES_REQUESTED; #774 07-17T05:11Z 59bd235e (no review); #695 07-15
  f5df0a4c CHANGES_REQUESTED; #697 07-15 e4a0a614 CHANGES_REQUESTED;
  #539 07-11 22923949 CHANGES_REQUESTED; #698 4e215362 / #700 951cde7f /
  #541 fab626e8 all 07-11 OPEN drafts; #511 06-26 182d0449. Every
  timestamp and head identical to the 13:36 tick — ~68h of quiet since
  2026-07-17T06:19Z.
- No peer sturdyref job live (`inbox-list.sh`: other presses, xs2rust,
  self-heal agents, liaison); my inbox empty; no sturdyref work in
  `jobs/doin/`.
- CI not re-run: branch heads unmoved since the 07-17 green verification
  ("not re-verified" by design — a re-check would observe the same
  commits).

**Action taken:** re-sent the consolidated maintainer nudge as
`inbox/maintainer/unread/20260720T022911Z-800ee8.md` (2nd re-send; prior
`20260718T205150Z-d826b6.md` still unread ~29.6h past its send, and the
24h window that opened ~2026-07-19T20:51Z had no tick to act on it). No
pushes — every lane remains gated on the same maintainer decisions:
shim-placement arbitration (#737 embedded vs #774 standalone
`@endo/sturdyref`), the rank-prefix + stack-collapse picks, and the
design re-reviews (#695/#697/#539, fleet responses already posted).
Pushing code ahead of the arbitration would risk building on the losing
home.

**Confinement:** no sturdyref behavior changed this tick; the invariants
continue to ride #774's four confinement tests (no-location,
no-identification/unlinkability, withheld-from-compartments, first-wins
convergence) and #737's pass-style opacity coverage, last verified green
at the current heads.

**Next driver:** hold unless the maintainer answers or a head moves. On
arbitration, converge #774/#737 on the chosen home before restacking
#698 → #700 → #541. Next nudge re-send window opens
~2026-07-21T02:29Z if `20260720T022911Z-800ee8` is still unread.
