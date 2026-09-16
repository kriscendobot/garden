---
created: 2026-09-16
author: gardener
---

# Skill: ownership-map

A **checkable design artifact**: the table a design must carry when it spans more
than one component or architectural layer, stating — before review — who owns each
responsibility at every boundary. The map exists so a design cannot assign
execution, durability, or lifecycle responsibilities to the wrong layer without the
mismatch being visible on the page, and so a reviewer can reconstruct and challenge
the boundary from an explicit statement rather than from scattered prose.

## Purpose

Grounding: the architectural-boundary-ownership review-miss cluster
(`review-misses/clusters/architectural-boundary-ownership.md`, member
`endojs/endo-but-for-bots#1018`). A design for Ironhorse panic handling put an
engine-side `CrankOutcome` at the Ironhorse `Machine` seam and described the engine
worker as owning transcript state, while supervisor-side prose separately owned
durable release, discard, restart, and replay. Six design-panel rounds checked
local consistency and caught nearby symptoms, but no seat assembled the ownership
map that would have shown the engine layer classifying execution termination while
the Slot Machine supervisor owned snapshots, transcript durability, embargo, and
crank-commit policy. `CrankOutcome` imported an outer-layer lifecycle concept (a
*crank* — an outer commit/lifecycle unit) into an inner engine result type for an
engine that only evaluates and runs to quiescence; the later correction renamed it
`ExecutionOutcome`. An explicit ownership map, written before review, makes that
conflict impossible to miss.

## When to use

The designer consults this skill (via `roles/designer/AGENT.md` § Operating norms)
whenever a design **spans two or more components or architectural layers** — an
engine and its supervisor, a mechanism and a persistence store, a client and a
server, an inner runtime and an outer coordinator. A single-component design that
touches one layer does not owe a map. When in doubt, write the map: it is cheap and
it is exactly the artifact the design panel reconstructs.

## The artifact

A section titled **`## Ownership map`** carrying a table with **one row per
boundary** the design crosses. Each row states, for that boundary, five things:

| Column | What it records |
| --- | --- |
| **Boundary** | the two sides, named (e.g. `engine → supervisor`). |
| **Mechanism** | the pure capability each side provides — what it *does*, with no policy. |
| **Policy** | who *decides* (commit vs discard, retry vs fail, admit vs reject). |
| **Durable state** | who owns the persistent state (snapshot, transcript, store) — exactly one side per datum. |
| **Lifecycle / commit authority** | who owns restart, replay, and the commit/discard decision. |
| **Value crossing** | the concrete value that crosses the boundary, and which layer's vocabulary names it. |

Below the table, answer the **four ownership questions** in prose for the whole
design (they are what the design-panel check reconstructs):

1. **Who owns persistent/durable state?** Each durable datum belongs to exactly one
   layer; if two layers touch it, name the single owner and the other's read/derive
   role.
2. **Who owns the commit/discard decision?** The authority that decides an effect is
   kept or thrown away.
3. **Who owns restart/replay?** The authority that recovers a component and replays
   its inputs.
4. **Who owns execution classification?** The layer that decides *how execution
   ended* (committed / threw / terminated) — distinct from the layer that decides
   *what to do about it*.

## The inner/outer naming check

State it explicitly, then verify the design obeys it: **an inner mechanism must not
be named for an outer-layer lifecycle concept.** An engine that only evaluates and
runs to quiescence returns an *execution* result, not a *crank* result — a crank is
an outer commit/lifecycle unit owned by the supervisor. Walk the design's type and
API names and flag any that fuse an outer-layer lifecycle word (crank, commit,
transaction, snapshot, replay, embargo, checkpoint, rollback, durable, persist)
onto an inner-mechanism result/handle/status/context type. The `CrankOutcome`
→ `ExecutionOutcome` rename is the canonical example.

## Output shape

The `## Ownership map` section lands in the design document itself, before the
design goes to review, alongside the design's own `## Design` / `## Approach`
content. It is normative design content, not a review scratchpad; it stays in the
document after merge as the durable statement of the boundary.

## Notes

- **The map is the review surface, not a summary.** Its value is that the design
  panel (`skills/panel`, the decomplector seat) reconstructs the same map and
  challenges it. A design that carries an explicit, coherent map is *not* penalized
  for naming multiple layers; a design that spans layers with the ownership only
  implicit in prose is exactly the shape the sensor flags.
- **Sensing side.** The deterministic design-panel pre-pass
  `scripts/jobs/gardening/ownership-map-signal.sh` detects a multi-layer design,
  reports whether this section is present, and surfaces fused inner/outer name
  candidates to the decomplector; see `skills/panel-hints` § Design-panel routing.
- **Keep it to one screen.** One row per boundary and four short answers. A map that
  needs more than a handful of rows is a signal the design spans too much and should
  split into sibling designs (`roles/designer/AGENT.md` § Operating norms, length).
