---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-20T21:07:33Z
---
# SturdyRef press — 21:05 dispatch tick (no movement; holding; nudge window opens ~02:29Z)

Tick action: hold + observation. Verified live (~21:07Z, 2026-07-20) that
nothing has moved since the 14:51 tick
(`entries/2026/07/20/145242Z-progress-gardener-023736.md`).

**Verified live (`gh pr view --json state,isDraft,updatedAt,headRefOid,reviewDecision`
against endojs/endo-but-for-bots, ~21:07Z):**
- #737 2026-07-17T06:19:35Z b56b3465 CHANGES_REQUESTED; #774 07-17T05:11Z
  59bd235e (no review); #695 07-15 f5df0a4c CHANGES_REQUESTED; #697 07-15
  e4a0a614 CHANGES_REQUESTED; #539 07-11 22923949 CHANGES_REQUESTED;
  #698 4e215362 / #700 951cde7f / #541 fab626e8 all 07-11 OPEN drafts;
  #511 06-26 182d0449. Every timestamp and head identical to the 14:51
  tick — ~86.8h of quiet since 2026-07-17T06:19Z.
- No peer sturdyref job live (`inbox-list.sh`: sibling presses —
  byte-array, daemon-data-plane, git-integration, npm-cas-registry,
  vfs-parity — plus xs2rust agents, pr811-weave (durable MapStore, not
  sturdyref), self-heal agents, liaison); my inbox empty; `jobs/doin/`
  holds only xs2rust work.
- CI not re-run: branch heads unmoved since the 07-17 green verification
  ("not re-verified" by design — a re-check would observe the same
  commits).

**Action taken:** none beyond verification. The 02:29 consolidated
maintainer nudge (`inbox/maintainer/unread/20260720T022911Z-800ee8.md`)
is still unread (~18.6h old); its 24h re-send window opens
~2026-07-21T02:29Z — about 5.4h after this tick, so no re-send. Every
lane remains gated on the same maintainer decisions: shim-placement
arbitration (#737 embedded vs #774 standalone `@endo/sturdyref`), the
rank-prefix + stack-collapse picks, and the design re-reviews
(#695/#697/#539, fleet responses already posted). Maintainer inbox
backlog grew 133 → 146 unread since the 14:51 tick, so the gate likely
persists; per the standing note, keep the re-send cadence rather than
escalate.

**Confinement:** no sturdyref behavior changed this tick; the invariants
continue to ride #774's four confinement tests (no-location,
no-identification/unlinkability, withheld-from-compartments, first-wins
convergence) and #737's pass-style opacity coverage, last verified green
at the current heads.

**Next driver:** hold unless the maintainer answers or a head moves. The
first tick at or after ~2026-07-21T02:29Z should re-send the nudge if
`20260720T022911Z-800ee8` is still unread. On arbitration, converge
#774/#737 on the chosen home before restacking #698 → #700 → #541.
