---
title: isFake (deprecated)
source: packages/harden/README.md
source_repo: endojs/endo
source_commit: 20a61e3d
source_date: 2025-10-10
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
parent: endo--pkg-harden-readme--overview
---

Using `lockdown` with the deprecated `"unsafe"` `hardenTaming` option
creates an environment where `Object.isFrozen`, `Object.isExtensible`,
`Reflect.isExtensible`, and `isSealed` all misreport that any object is
frozen, non-extensible, and sealed.
To indicate this, `harden.isFake` is `true`.

We regret this misfeature.
The `@endo/harden` does not provide `harden.isFake`.
Code, especially tests, migrating to use `@endo/harden` should refactor
`harden.isFake` to use a more legible indicator of the misbehavior of `isFrozen`
and its compatriots, which may not be indicated by empirical behavior of `harden`.

For example, `Object.isFrozen({})` when `harden.isFake` and more clearly
conveys the reason a test might be invalidated by `unsafe` `hardenTaming`.
Testing that the outcome of `Object.isFrozen({})` is the same as the outcome of
`Object.isFrozen(object)` for an object that should not be frozen makes a test
work just as well between `safe` and `unsafe` `hardenTaming`.

The module `@endo/harden/is-noop.js` provides `hardenIsNoop(harden)` to
detect whether `harden` is a no-op, regardless of `hardenTaming`.
Do not rely on `Object.isFrozen({})` to imply that `harden` is a no-op.

```js
import harden from '@endo/harden';
import hardenIsNoop from '@endo/harden/is-noop.js';

if (hardenIsNoop(harden)) {
  // ...
}
```

Source: [packages/harden/README.md](https://github.com/endojs/endo/blob/20a61e3d/packages/harden/README.md) at commit `20a61e3d`.
