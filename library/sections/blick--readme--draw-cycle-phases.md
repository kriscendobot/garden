---
title: The draw cycle — measure, transition, animate, draw, redraw phases
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

Abstract: Each component asks the animator to call it back in specific phases via `requestMeasure`/`requestTransition`/`requestAnimation`/`requestDraw`/`requestRedraw` (each with a matching `cancel*`), and implements the corresponding `measure`/`transition`/`animate`/`draw`/`redraw` methods. Every animation frame runs the five phases in order; in each phase every component that requested it executes together. **measure** reads rendered state (size, position, computed styles) and may request or cancel later phases based on what it finds; a component must re-request measurement for a subsequent frame. **transition** sets up a CSS transition's initial state (skipped for a frame if the component also requested a draw/redraw first, with the transition staying scheduled). **animate** runs every frame until explicitly cancelled. **draw** is intended to run once when a component enters the document. **redraw** runs when requested and must be re-requested each time. Batching all reads (measure) apart from all writes (draw/redraw) is what avoids forced reflow.

The animation controller expects that the component will request that the animator call certain methods to perform animation, transitions, or rendered document queries.

```js
animator.requestMeasure();
animator.requestTransition();
animator.requestAnimation();
animator.requestDraw();
animator.requestRedraw();

animator.cancelMeasure();
animator.cancelTransition();
animator.cancelAnimation();
animator.cancelDraw();
animator.cancelRedraw();

component.measure();
component.transition();
component.animate();
component.draw();
component.redraw();
```

In each animation frame, each of the following phases will be executed. In each phase, every component that has requested that phase will execute.

- **measure:** The animation controller will call `measure()` on every component that has requested an opportunity to measure its rendered state on the document in the first phase of the next animation frame. This may include measuring its size, position, or computed styles. The component may at this point decide whether to request or cancel any subsequent phases depending on whether the measured state reflects the intended state. The component will need to request another measurement if it wishes to do so on a subsequent animation frame.

- **transition:** The transition phase is for setting up CSS transitions. If a CSS transition does not proceed from the current state on document, you use the transition phase in one animation frame to set up the initial state. You can simultaneously schedule a draw or redraw to follow up with the transition to the intended final state. The animation controller will call `transition()` on every component that has requested a transition on the next animation frame. If a component has requested that it have an opportunity to draw or redraw before it starts a transition, this phase will be skipped for this animation frame and the transition will remain scheduled. Once the transition has been initiated, the component will need to request another opportunity to transition if it wishes to make a change in a subsequent animation frame.

- **animate:** The animation controller will call `animate()` on every component that has requested an opportunity to animate on every animation frame. The component must explicitly cancel animation if it wishes to stop animating.

- **draw:** The animation controller will call `draw()` on every component that has requested an opportunity to draw itself onto the document on the next animation frame. Drawing is intended to occur only once when a component enters the document.

- **redraw:** The animation controller will call `redraw()` on every component that has requested an opportunity to redraw itself onto the document on the next animation frame. If the component wishes to redraw, it must request another opportunity to redraw.

Source: [README.md](https://github.com/gutentags/blick/blob/a8b700480d23d311171f87cca3ea5efcae8f3d7a/README.md) at commit `a8b7004`.
