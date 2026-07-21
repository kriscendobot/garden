# Revise design PR #809 — full persistent collection family in the pet daemon

Maintainer kriskowal has redirected the design at
https://github.com/endojs/endo-but-for-bots/pull/809 . Previously the design
proposed a scalar `MapStore`; a subsequent challenge suggested a directory-backed
facade; kriskowal has now settled the direction: **direct implementation** of the
full collection family on the daemon's own substrate (formula + SQLite,
`@endo/patterns` for keys/patterns, no `@agoric/*` dependency).

Repo: endojs/endo-but-for-bots. Branch: `daemon-persistent-stores` (PR #809,
DRAFT). Design doc: `packages/daemon/designs/daemon-persistent-stores.md`.

Revise the design doc to broaden scope from "scalar MapStore" to the whole family:

- `MapStore` / `SetStore` — strong; scalar keys first, then full `M.key()` keys.
  Remotable entries join the retention graph (strong store retains keys+values).
- `WeakMapStore` / `WeakSetStore` — keys held weakly, NO retention edge to the
  key; entry drops when the key's formula is collected. Spell out how weak-key GC
  interacts with the daemon's formula refcount/retention graph.
- `SortedMapStore` / `SortedSetStore` + range queries over arbitrary passable
  keys — store each key's rank-order encoding (`@endo/marshal` `makeEncodePassable`,
  the same rank order `@endo/patterns` / `@agoric/store` sorted stores use) as an
  indexed SQLite column so `keys(pattern)` and bounded scans are O(log n) range
  scans.

Keep the phasing incremental, each variant landing with restart-persistence
tests: strong `MapStore` → `SetStore` → weak variants → sorted variants + range
queries. Update the design's SQLite schema, formula-type, and interface sections
accordingly. This is a design revision (draft PR stays draft); do not implement.
Comment on the issue thread only if there is a design question for the maintainer
— the direction acknowledgment has already been posted.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-59
issue_url: https://github.com/kriskowal/garden/issues/59#issuecomment-5030189831
submitter: dckc
----- END ISSUE NOTE -----

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  claimed_at: 2026-07-21T04:43:14Z
