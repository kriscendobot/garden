---
title: Ecosystem Compatibility
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, tooling]
status: current
---

> Abstract: What works (and what does not) when SES is applied to common JS ecosystem libraries. Some packages assume mutable primordials or unrestricted Date.now; SES breaks them. The README lists known-incompatible patterns and the Compartment-endowment workarounds for the common cases.

## Ecosystem Compatibility

Most ordinary JavaScript can run without issues in a realm locked down by SES.
Exceptions are tracked at [issue #576][incompatibility tracking], and almost
always take the form of assignments that fail because the
"[override mistake][override mistake]" prevents overriding properties inherited
from a frozen intrinsic object in the prototype chain. When that is the case,
the code is often incompatible with *all* environments in which intrinsic
objects are frozen (such as in Node.js with the
[`--frozen-intrinsics`][Node frozen intrinsics] option) and can be fixed by
replacing `<lhs>.<propertyKey> = <rhs>;` or `<lhs>[<propertyKey>] = <rhs>;` with

```js
Object.defineProperties(<lhs>, {
  [<propertyKey>]: {
    value: <rhs>,
    writable: true,
    enumerable: true,
    configurable: true,
  },
});
```

Upon encountering an incompatibility, we recommend that you add a comment to
[issue #576][incompatibility tracking] and file an issue with the external
project referencing this section.
Projects often have their own unique issue reporting templates, but generally
provide some place to include text like

> ```
> This project has some assignments that break in an environment with frozen
> intrinsic objects, such as
> [Hardened JS (a.k.a. SES)](https://github.com/endojs/endo/blob/master/packages/ses#ecosystem-compatibility)
> or Node.js with the
> [`--frozen-intrinsics`](https://nodejs.org/docs/latest/api/cli.html#--frozen-intrinsics)
> option.
> Specifically, [link to source in the project] does not work correctly in such
> an environment.
>
> Please consider increasing support by replacing assignments to object
> properties inherited from intrinsics with use of `Object.defineProperties`
> (thereby working around the JavaScript "override mistake"), and if applicable
> also by avoiding mutation of intrinsic objects.
> If you don't have the capacity but would accept a PR, please comment to that
> effect so that a volunteer knows their efforts would be welcomed.
> ```

We find that library authors are generally amenable to making these small changes to increase
compatibility with any environment that protects itself from prototype pollution attacks by freezing
intrinsics, including `ses`.

[Hardened JavaScript]: https://hardenedjs.org/
[define shim]: https://en.wikipedia.org/wiki/Shim_(computing)
[Endo Matrix]: https://matrix.to/#/#endojs:matrix.org
[incompatibility tracking]: https://github.com/endojs/endo/issues/576
[Node frozen intrinsics]: https://nodejs.org/docs/latest/api/cli.html#--frozen-intrinsics
[override mistake]: https://web.archive.org/web/20141230041441/http://wiki.ecmascript.org/doku.php?id=strawman:fixing_override_mistake
[SECURITY.md]: https://github.com/endojs/endo/blob/master/packages/ses/SECURITY.md
[SES Issues]: https://github.com/endojs/endo/issues
[SES proposal]: https://github.com/tc39/proposal-ses
[SES Strategy Group]: https://groups.google.com/g/ses-strategy
[SES Strategy Recordings]: https://www.youtube.com/playlist?list=PLzDw4TTug5O1jzKodRDp3qec8zl88oxGd

Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md) at commit `fe81477b`.
