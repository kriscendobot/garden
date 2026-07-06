---
id: kamera-single-focus
aliases: [kamera, Kamera, single focus, focus enforcement, takeFocus, attention.takeFocus, scope.attention, one component has focus, blur prior focal component]
topics: [focus-management, html-modules]
---

# kamera-single-focus

**Kamera** (`gutentags/kamera`) is a singleton that enforces the invariant that
at most one component in a Guten Tag application holds focus at a time. It is
injected at the **root scope** (`scope.attention = new Kamera()`) so a single
instance is shared by every child component and widget — the same
dependency-injection pattern that shares the [[animation-coordination|Blick]]
animator and the [[module-loader|System]] loader across a scope. A widget reads
the shared kamera as `this.attention` and calls `this.attention.takeFocus(this)`
from its own `focus` method; `takeFocus` **implicitly calls `blur` on the prior
focal component** before recording the new one, so each widget need only
implement a `blur` method that reverses whatever its `focus` did. Single-focus
enforcement thus becomes an application-wide invariant coordinated through one
injected object rather than pairwise between widgets.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [kamera--readme--overview](../sections/kamera--readme--overview.md) | The kamera singleton, root-scope injection, and the blur-the-prior-focal-component rule. |
| [kamera--readme--focus-api](../sections/kamera--readme--focus-api.md) | The `takeFocus(this)` / `blur()` widget contract and its wiring through `scope.attention`. |

## See also

- [[guten-tag-scope]] — the scope object whose root holds the injected `attention` (kamera) singleton.
