---
title: Overview — a component animation controller that batches reads and writes
source: README.md
source_repo: gutentags/blick
source_commit: a8b700480d23d311171f87cca3ea5efcae8f3d7a
source_date: 2015-05-31
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [animation-coordination, html-modules]
status: current
---

Abstract: Blick is a JavaScript component animation controller built on the low-level animation-frame handler. The animator batches reads and writes by coordinating measurement, transitions, animation, drawing, and redrawing, and each component retains its own part of the controller so there is no garbage-collector churn frame to frame. This coordinated draw cycle enables cooperative scenarios: components that must measure their bounding boxes before drawing, that must redraw every frame because their model changes continuously, that draw once then redraw on discrete changes, that set an initial position (transitions disabled) in one frame and a target position (transitions enabled) in the next, or that resize text until it fits a bounding box exactly. The controller is typically shared across a scope by dependency injection — with Guten Tag, `scope.animator = new Blick()`.

Blick is a JavaScript component animation controller based on the lower level animation frame handler. The animator batches reads and writes by coordinating measurement, transitions, animation, drawing, and redrawing. Each component retains its own part of the animation controller so there is no garbage collector churn frame to frame. This coordinated draw cycle enables a wide variety of cooperative scenarios:

- Components that need to measure their bounding boxes before drawing.
- Components that need to redraw on every animation frame because their model changes continuously.
- Components that need to draw initially then redraw in response to discrete model changes.
- Components that need to set their initial position (with transitions disabled) in one animation frame, and set their target position (with transitions enabled) in a subsequent animation frame.
- Components that need to resize text until it fits the bounding box exactly.

Installation:

```
npm install --save blick
```

Just to get started, create an animation controller and add a component. This will create and return an animation controller for your component.

```js
var Animator = require("blick");
var animator = new AnimationController();
component.animator = animator.add(component);
```

Typically, the animator will be shared by all of the components in a scope through some form of dependency injection. For example, with [Gutentag](https://github.com/gutentags/gutentag), you would add the animator to the scope shared by all or some components.

```js
var Scope = require("gutentag/scope");
var Blick = require("blick");
var scope = new Scope();
scope.animator = new Blick();
```

This component requests a color change each time its value changes.

```js
function ColorComponent(body, scope) {
    this.element = body.ownerDocument.createElement("div");
    body.appendChild(this.element);
    this.animationController = scope.animator.add(this);
    this._value = null;
}

ColorComponent.prototype.destroy = function destroy() {
    this.animationController.destroy();
};

Object.defineProperty(ColorComponent.prototype, "value", {
    get: function () {
        return this._value;
    },
    set: function (value) {
        this._value = value;
        this.animationController.requestDraw();
    }
});

ColorComponent.prototype.draw = function () {
    this.element.actualNode.style.color = this._value;
};
```

Source: [README.md](https://github.com/gutentags/blick/blob/a8b700480d23d311171f87cca3ea5efcae8f3d7a/README.md) at commit `a8b7004`.
