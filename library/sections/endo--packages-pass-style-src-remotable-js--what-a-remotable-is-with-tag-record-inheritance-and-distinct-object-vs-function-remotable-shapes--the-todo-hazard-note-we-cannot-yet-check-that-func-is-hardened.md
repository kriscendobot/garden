---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §TODO HAZARD note — *we cannot yet check that func is hardened*
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The §JSDoc carries an honest hazard acknowledgement:

> *TODO HAZARD Because we check this on the way to hardening a
> remotable, we cannot yet check that `func` is hardened. However,
> without doing so, its inheritance might change after the
> PASS_STYLE check below.*

The §timing-hazard: `canBeMethod` is called *during* the harden
process; the function may not yet be hardened, so its prototype
chain may still mutate after the PASS_STYLE check. The discipline
acknowledges the gap *without resolving it* — a deliberate
*known-limitation-marker*.
