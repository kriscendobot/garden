# Topic: animation-coordination

> Abstract: **Blick** (`gutentags/blick`), Guten Tag's component animation controller, and the read/write-batching discipline it embodies. Blick sits over the browser's low-level animation-frame handler and coordinates a five-phase draw cycle — **measure** (read rendered state), **transition** (set up a CSS transition's initial state), **animate** (per-frame), **draw** (once on entry), **redraw** (on demand) — so that all components *query* the rendered document together, apart from when they all *write* to it, avoiding forced reflow. Each component gets a reusable per-component controller (animation is sensitive to GC churn) and requests/cancels phases explicitly; the controller is typically shared across a Guten Tag scope by dependency injection. Its design rationale spans three levels: throttling document changes to perceptible rates, coordinating reads apart from writes to avoid redundant reflow, and solving the CSS-transition two-frame problem (a transition that must start from a position different from the current one requires yielding to the renderer between setting initial and final state). Seeded 2026-07-06 from the Blick README. Distinct from `html-modules` (the component framework Blick's animator injects into) and `change-propagation` (incremental data-change theory, not frame scheduling).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [blick--readme--overview](../sections/blick--readme--overview.md) | blick README | Blick: a component animation controller batching reads and writes over the animation-frame handler, with a reusable per-component controller and cooperative scenarios (measure-before-draw, continuous redraw, text-fit resizing). |
| [blick--readme--draw-cycle-phases](../sections/blick--readme--draw-cycle-phases.md) | blick README | The request/cancel API and the five per-frame phases (measure/transition/animate/draw/redraw), each running for every component that requested it — reads (measure) batched apart from writes (draw/redraw). |
| [blick--readme--design-rationale](../sections/blick--readme--design-rationale.md) | blick README | Three levels: throttle document changes to perceptible rates, coordinate queries apart from draws to avoid forced reflow, and solve the CSS-transition two-frame problem with separate redraw/transition frames. |

## See also

- [`html-modules`](html-modules.md): Guten Tag, whose scope shares a `Blick` animator across components by dependency injection.
- [`virtual-dom`](virtual-dom.md): Koerper/Wizdom, the document Blick's `draw`/`redraw` phases write into (`element.actualNode`).
- [`change-propagation`](change-propagation.md): incremental change-reflection theory; Blick is the frame-scheduling layer beneath such reactivity, not the propagation model itself.
