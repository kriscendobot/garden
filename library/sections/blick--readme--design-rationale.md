---
title: Design rationale — three levels of coordinating document reads and writes
source: README.md
source_repo: gutentags/blick
source_commit: a8b700480d23d311171f87cca3ea5efcae8f3d7a
source_date: 2015-05-31
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [animation-coordination]
status: current
---

Abstract: The problem Blick solves, at three levels. **First**, components should modify the document no more often than changes can be perceived — trading time spent altering the document for time and memory spent *planning* to alter it (browsers rarely render faster than 60fps, giving at most ~17ms of main-thread CPU per frame). **Second**, certain interleavings of document alterations and queries force the document to render (reflow/redraw) more often than necessary; the cure is to coordinate so that all components query together either *before* or *after* all components draw. **Third**, CSS animations pose a challenge: an ideal JS animation API would let a component set initial state, final state, and duration atomically, but CSS transitions require yielding to the renderer *between* setting the initial state and initiating the transition — a problem only when a transition must start from a position different from the current one (common for games and live-data visualizations). Blick's answer: a system where components coordinate when they alter or query the rendered document, with separate "redraw" and "transition" frames per component, and a reusable per-component controller (animation is sensitive to GC churn). Blick deliberately does *not* order components' animation relative to each other — information should flow only from phase to phase.

On one level, it is useful for components to modify the document no more frequently than those changes can be perceived. At this level of consideration, the developer trades time spent altering the document for time and memory spent planning to alter the document.

Browsers will typically avoid rendering changes to a page more frequently than 60 frames per second. Regardless, the user has at most 17 milliseconds of time on the CPU in the main JavaScript worker to prepare and apply each frame of animation on a page.

Certain combinations of alterations to a document and queries to the state of the rendered document can force the document to render more frequently than necessary. As such, on a second level, it is necessary for components to avoid causing the page to render (reflow or redraw) more frequently than those changes can be perceived. This can be achieved by coordinating changes and queries to the state of the rendered document, such that all components query together either before or after all components have an opportunity to draw themselves.

On a third level, the design of CSS animations poses a certain challenge. While an ideal animation API in JavaScript would permit each component to set its initial state, final state, and the duration of the change as an atomic operation, CSS transitions require the component to yield to the renderer between when they set the initial state and when they initiate a transition.

This is only ever a problem if a component needs to start a transition from a different position than its current position. This is often necessary for games or visualizations of live data. (The worked example in the README depicts a component receiving periodic position/velocity updates and using a `redraw` frame to jump to the initial position with transitions disabled, then a `transition` frame to move to the final position with a linear CSS transition; its vectors come from [ndim](https://github.com/kriskowal/ndim).)

To this end, Blick provides a system where components can coordinate when they alter or query the rendered document, as well as separating "redraw" and "transition" animation frames for each component. Also, because animation is sensitive to garbage collection churn, the animation library associates each component with a reusable animation controller object that is reused for the life of that component.

This library does nothing to ensure that components animated in any specific relative order since information about rendering should only flow from phase to phase.

Source: [README.md](https://github.com/gutentags/blick/blob/a8b700480d23d311171f87cca3ea5efcae8f3d7a/README.md) at commit `a8b7004`.
