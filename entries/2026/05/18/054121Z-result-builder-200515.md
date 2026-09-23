---
ts: 2026-05-18T05:41:21Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/18/053838Z-dispatch-builder-200515.md
  - entries/2026/05/18/054120Z-message-builder-200515.md
---

# Result: impasse on `daemon-retention-paths` Phase 1 (master-base prerequisite gap)

Slot-3 third pick of the cycle. Impasse at pre-flight gate #3
(existing-symbol check), but in the inverted form: the substrate
the design assumes (the private `listRetentionPaths` in
`packages/daemon/src/graph.js`) does **not** exist on `master`.
That file and the entire GC + formula-graph machinery the design
builds on live only on the `llm` roadmap branch.

PR URL: none (impasse before branch).
Branch name: not created.
Base: would have been master per dispatch.
Affected files: none.
Test count: zero (no implementation written).
CI status: not applicable.
Out-of-scope deferrals: not applicable (no Status update made).

## Pre-flight gate outcomes

1. Open-PR slug check: pass. No open or merged implementation PR.
   Design PR #181 already merged; no overlapping work.
2. Design-status drift check: pass. `Status: Not Started` on `llm`;
   master has no `designs/` directory by convention.
3. Existing-symbol check: pass on the literal terms (no host method
   named `listRetentionPaths` exists on master), but **fails on the
   implicit prerequisite** (the private `listRetentionPaths` in
   `graph.js` that the dispatch said was "already there" does not
   exist on master either; it exists only on `llm`).

## Impasse details and recommendation

Full analysis routed to liaison in `054120Z-message-builder-200515.md`.
Key points:

- The design's entire named substrate (`graph.js`, `addLabeledEdge`,
  `extractLabeledDeps`, `formulaGraph`, `formulaChangeTopic`,
  `onPetStoreWrite`, `transientRoots`, `retention-accumulator.js`,
  the `RetentionPath` / `RetentionPathSegment` types) is `llm`-only.
- The only design-named symbols on `master` are the bare scaffolding
  (`formulaGraphJobs`, `cancelValue`, the `EndoHost` exo).
- A Phase-1 PR on master-base would require first porting the entire
  GC track from `llm` to `master`. That is a multi-PR migration, not
  the surfacing-of-an-existing-private-function the design describes.
- Cleanly separable alternatives for the maintainer to choose between
  are in the liaison message: (a) implement Phase 1 on an `llm`-base
  PR, or (b) promote the GC substrate from `llm` to `master` as a
  prerequisite track.

Recommendation to the contractor: turn this slot's pick over and
add the substrate-on-base gate to the pick algorithm. This is the
third consecutive slot-3 impasse in the same contractor cycle; the
pattern is now strong enough to act on. The contractor's existing
self-improvement note (`054016Z-message-general-contractor-pickfilter.md`)
already proposes a slug-keyword gate; the substrate-on-base gate is
a sibling addition.

Self-improvement: the dispatch's pre-flight gates as written check
for *conflicting* symbols on the implementation base ("does the host
method already exist?") but not for *prerequisite* symbols ("does the
private function the design wants to surface actually exist on the
base branch?"). The latter would catch this class of impasse. A
small wording change on the dispatch template's gate #3 ("Existing-
symbol check") to include both directions would have surfaced this
in two grep calls instead of one. Routed to liaison in this same
message for inclusion in the contractor pick-algorithm addendum.
