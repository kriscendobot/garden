# Topic: focus-management

> Abstract: **Kamera** (`gutentags/kamera`), Guten Tag's single-focus enforcer, and the injected-singleton pattern by which it makes "at most one component is focused" an application-wide invariant. The kamera is a singleton stored on the root scope (`scope.attention = new Kamera()`) so every child component and widget shares one instance; a widget calls `this.attention.takeFocus(this)` from its `focus` method, and the kamera blurs the prior focal component — implicitly invoking that component's `blur` — before recording the new one. This is the focus-coordination peer of the other dependency-injected coordinators a Guten Tag scope shares: the [`animation-coordination`](animation-coordination.md) animator (Blick) and the [`module-loader`](module-loader.md) loader (System). Seeded 2026-07-06 from the Kamera README. Distinct from `html-modules` (the component framework whose scope injects the kamera) — this topic is specifically the single-focus discipline and its API.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [kamera--readme--overview](../sections/kamera--readme--overview.md) | kamera README | The kamera: a singleton injected at the root scope that ensures only one component holds focus, blurring the prior focal component when a new one takes focus. |
| [kamera--readme--focus-api](../sections/kamera--readme--focus-api.md) | kamera README | The widget contract: hold `scope.attention`, call `takeFocus(this)` from `focus`, and implement `blur` to reverse `focus` — `takeFocus` blurs the prior focal component implicitly. |

## Concepts

- [[kamera-single-focus]] — the injected-singleton pattern enforcing at-most-one focused component.

## See also

- [`html-modules`](html-modules.md): Guten Tag, whose root scope injects a `Kamera` shared by every child component and widget.
- [`animation-coordination`](animation-coordination.md): Blick, the animator a Guten Tag scope shares by the same root-scope dependency-injection pattern.
- [`module-loader`](module-loader.md): System, the module loader likewise shared across a Guten Tag application.
