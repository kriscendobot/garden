# Design: a Sussman/Radul propagator at the Endo and Exo layers

Wear the **designer** role (`roles/designer/AGENT.md`). Design a **propagator** in the
**Sussman/Radul** model, implemented at the **Endo layer** and **lifted to passable at
the Exo layer**, as **hardened** modules. Deliverable: a design document opened as a
DRAFT PR on the project roadmap branch (`endojs/endo-but-for-bots` `llm`) for maintainer
review. This is the design the change-propagation scholarship flagged as missing
(propagators were grounded only as external lineage; now design them properly).

## The model (Sussman/Radul propagators)

Ground the design in the propagator model from Radul & Sussman ("The Art of the
Propagator" / Radul's thesis) — cite it as the external lineage it is:
- **Cells** hold **partial information** about a value (a point in a lattice / a
  merge-able accumulator), not a single assignment. A cell accumulates content via a
  **merge** that is monotonic, commutative, idempotent (lattice join); contradictory
  merges are detected.
- **Propagators** are monotonic agents that watch cells and, when their inputs gain
  information, add information to their output cells. Propagation is **multidirectional**
  (constraints, not functions) and runs to a fixed point via a scheduler.
- Optional: dependency tracking / truth maintenance (provenance, retraction) — design
  whether to include it or leave a seam for it.

## Endo layer (the implementation)

Design the plain **Endo** modules: the **cell** interface (content, `addContent`/merge,
watchers/neighbors), the **propagator** interface (register inputs/outputs, the activation
on input change), the **scheduler** (alert queue → run to quiescence), and the **merge /
partial-information lattice** contract (how a domain plugs in its lattice: nothing / value
/ interval / set / contradiction). **Hardening**: SES `harden`, no ambient authority,
defensive against untrusted callers, and clean teardown/GC of cell↔propagator links (no
leaks via the neighbor graph). Relate to the in-corpus precedent the scholar identified:
FRB two-way (`<->`) bindings are the one in-corpus multidirectional-constraint instance —
note how the propagator generalizes it.

## Exo layer (lift to passable)

Design how cells and propagators become **passable / remotable exo objects**, so
propagation can **span vats/agents** and a cell's partial information flows across the
membrane. Cover: which facets are passable; **async, eventual merge across vats** (a
remote cell gains information by eventual-send, merge still monotonic so order/duplication
are tolerated — tie this to the change-propagation through-line of *idempotent
convergence*); contradiction handling across the membrane; and the ocap discipline (a
cell/propagator reference is an attenuable capability, not ambient authority).

## Situate it in the change-propagation theory

Connect to the curated library (topic `change-propagation`): the propagator cell's
lattice-merge is the **idempotent-convergence** face; relate it to *latest* (convergent
current-value) vs *changes* (order-significant deltas), and to FRB observers and
@endo/pubsub topics — propagators being the **multidirectional** member of the family.
Consult `journal/library/{concepts,topics}/…change-propagation…` and the
`sliding-window-topic` draft. Researcher precedence: read the scholar's curation and the
Sussman/Radul sources first; cite what you read; do not assert mechanism you cannot ground.

## Definition of done

A self-contained design doc (problem, the cell/propagator/merge/scheduler model at Endo,
the passable lift at Exo with async cross-vat merge, hardening + ocap discipline, the
relation to the change-propagation family, phased plan, open questions), opened as a DRAFT
PR on `endojs/endo-but-for-bots` `llm` under the bot identity, for maintainer review.
Report the PR number and the design slug. Cite the Sussman/Radul lineage as external;
ground Endo/Exo/FRB/pubsub claims in source.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 26
  claimed_at: 2026-06-25T16:45:15Z
