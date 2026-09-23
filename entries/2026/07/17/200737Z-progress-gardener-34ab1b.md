---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T20:07:38Z
---
# SturdyRef press — 20:05 dispatch tick (no movement; consolidated nudge RE-SENT)

Nudge-and-hold tick. Verified live (20:06Z) that nothing has moved since the
18:05 tick (`entries/2026/07/17/180709Z-progress-gardener-2d960e.md`).

**Verified live (`gh pr view` timestamps, all identical to the last four ticks):**
- endojs/endo-but-for-bots#737 updated 2026-07-17T06:19:35Z, CHANGES_REQUESTED,
  head b56b346534; endojs/endo-but-for-bots#774 05:11:07Z, no review, head
  59bd235e2b; endojs/endo-but-for-bots#695 07-15 CHANGES_REQUESTED;
  endojs/endo-but-for-bots#697 07-15 CHANGES_REQUESTED;
  endojs/endo-but-for-bots#539 07-11 CHANGES_REQUESTED;
  endojs/endo-but-for-bots#541 / #698 / #700 07-11, all OPEN MERGEABLE drafts.
  No pushes, reviews, or comments since.
- No peer sturdyref job live (`inbox-list.sh`: other presses + xs2rust agents
  only; `jobs/doin/` holds no sturdyref job); my inbox empty.
- CI not re-run this tick: branch heads unmoved since the 11:36Z green
  verification (b56b346534 / 59bd235e2b) — a re-check would observe the same
  commits; not re-verified this tick.

**Action taken:** the ~20:07Z re-send obligation came due — the consolidated
maintainer nudge `inbox/maintainer/unread/20260716T200737Z-72c74a.md` was still
unread at 24h with zero GitHub movement, so this tick RE-SENT it as
`inbox/maintainer` message `20260717T200708Z-5cde04` (three gates: #737-vs-#774
shim-placement arbitration; the rank-prefix + stack-collapse decisions on
endojs/endo-but-for-bots#737; design re-reviews #695/#697/#539). No code
pushed — holding so the single-commit review shape of #737 stays clean.

**Gate list (unchanged):** shim-placement arbitration endojs/endo-but-for-bots#737
(embedded-in-pass-style) vs endojs/endo-but-for-bots#774 (standalone
`@endo/sturdyref`); design re-reviews gating the agent provide/accept cuts A–F
(the "throughout" bar); bridge-cut restack (#698 → #700 → #541) pending the
arbitration outcome.

**Confinement:** no sturdyref behavior changed this tick; the invariants ride
endojs/endo-but-for-bots#774's four confinement tests (no-location,
no-identification/unlinkability, withheld-from-compartments, first-wins
convergence) and endojs/endo-but-for-bots#737's pass-style opacity coverage,
last verified green at the current unmoved heads.

**Next tick:** watch for kriskowal's arbitration / re-reviews and for a reply to
`20260717T200708Z-5cde04`; the re-send clock resets to ~2026-07-18T20:07Z. On
arbitration: converge #774/#737 on the chosen home, then restack the bridge cuts
(#698 → #700 → #541).
