---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §receiver-side — §four-case rendering fallback
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

The new `renderRejection` helper:

```js
const renderRejection = reason => {
  if (reason instanceof Error) {
    return `${reason.name}: ${reason.message}\n${reason.stack || ''}`;
  }
  if (
    reason &&
    typeof reason === 'object' &&
    reason['@@error'] === true
  ) {
    const { name = 'Error', message = '', stack = '' } = reason;
    return `${name}: ${message}\n${stack}`;
  }
  if (isPassable(reason)) {
    return passableAsJustin(reason);
  }
  return `(non-passable ${typeof reason}) ${String(reason)}`;
};
```

The §four-case-fallback ladder:

1. **Real `Error` instance** → `name: message\nstack`. (For
   local rejections that didn't go through the wire.)
2. **`'@@error': true` sentinel** → reconstruct as
   `name: message\nstack`. (For wire-received Errors.)
3. **Passable** (per `isPassable` from `@endo/marshal`) →
   `passableAsJustin(reason)`. (For non-Error reasons that
   *are* passable: strings, numbers, plain objects without
   remotables.)
4. **Non-passable** → `(non-passable <type>) String(reason)`.
   (Final defence: unbound functions, unregistered remotables,
   unknown reason types.)

The §`passableAsJustin`-not-`JSON.stringify` discipline:

> *`passableAsJustin` is the project-standard rendering for
> diagnostic display (per the Diagnostic Discipline rule in
> `CLAUDE.md`). It is unambiguous for remotables and promises,
> where `JSON.stringify` would strip them to `{}` or render
> them as `[object Object]`.*

The §use-marshal-for-display-not-wire distinction: marshal
*on the wire* requires marshal tables (rejected per
Alternative 1); marshal *for display* (via `passableAsJustin`)
is a *one-way* read-only render that doesn't depend on table
state. Cycle 84's rankOrder.js was an earlier appearance of
the same justin-rendering discipline.

The §`(non-passable <type>) String(reason)` final-defence
shape: even an unbound function gets *some* useful output
(`(non-passable function) function foo() { ... }`).
