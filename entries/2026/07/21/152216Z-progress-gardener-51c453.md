---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-21T15:22:18Z
---
# SturdyRef press — 15:20 dispatch tick (no movement; holding; next nudge window ~2026-07-22T03:07Z)

Tick action: hold + observation. Verified live (~15:2xZ, 2026-07-21) that
nothing has moved since the 09:22 tick
(`entries/2026/07/21/092236Z-progress-gardener-88d018.md`).

**Verified live (`gh pr view --json state,isDraft,updatedAt,headRefOid,reviewDecision`
against endojs/endo-but-for-bots):**
- #737 2026-07-17T06:19:35Z b56b3465 CHANGES_REQUESTED; #774 07-17T05:11Z
  59bd235e (no review); #695 07-15 f5df0a4c CHANGES_REQUESTED; #697 07-15
  e4a0a614 CHANGES_REQUESTED; #539 07-11 22923949 CHANGES_REQUESTED;
  #698 4e215362 / #700 951cde7f / #541 fab626e8 all 07-11 OPEN drafts;
  #511 06-26 182d0449. Every head and timestamp identical to the 09:22
  tick — ~105h of quiet since 2026-07-17T06:19Z.
- Latest comment on #737 remains kriscendobot 2026-07-17T05:15:59Z; no new
  maintainer comments on #737 or #774 (`gh api …/comments`, checked live).
- No peer sturdyref job live (`inbox-list.sh`: sibling presses only —
  byte-array, daemon-data-plane, git-integration, npm-cas-registry,
  vfs-parity — plus finbot, xs2rust, self-heal agents, liaison); my inbox
  empty; `jobs/doin/` holds no other sturdyref work.
- CI not re-run: branch heads unmoved since the 07-17 green verification
  ("not re-verified" by design — a re-check would observe the same
  commits).

**Action taken:** none beyond verification. The 3rd consolidated nudge
(`inbox/maintainer/unread/20260721T030731Z-9448bd.md`, sent 03:07Z) is
still unread (~12.2h old); its 24h re-send window opens
~2026-07-22T03:07Z, so no re-send this tick. Maintainer inbox backlog
grew 174 → 189 unread since the 09:22 tick — the gate persists; per the
standing note, keep the re-send cadence rather than escalate. Every lane
remains gated on the same maintainer decisions: shim-placement
arbitration (#737 embedded vs #774 standalone `@endo/sturdyref`), the
rank-prefix + stack-collapse picks
(endojs/endo-but-for-bots#737 issuecomment-4994276944), and the design
re-reviews (#695/#697/#539, fleet responses already posted). No pushes
to any branch — holding the single-commit review shapes.

**Confinement:** no sturdyref behavior changed this tick; the invariants
continue to ride #774's four confinement tests (no-location,
no-identification/unlinkability, withheld-from-compartments, first-wins
convergence) and #737's pass-style opacity coverage, last verified green
at the current heads.

**Next driver:** hold unless the maintainer answers or a head moves. The
first tick at or after ~2026-07-22T03:07Z should send the 4th re-send if
`20260721T030731Z-9448bd` is still unread. On arbitration, converge
#774/#737 on the chosen home before restacking #698 → #700 → #541.
