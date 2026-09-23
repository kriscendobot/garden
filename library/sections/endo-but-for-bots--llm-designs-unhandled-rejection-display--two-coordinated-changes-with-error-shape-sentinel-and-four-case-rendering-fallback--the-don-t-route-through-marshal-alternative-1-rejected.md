---
section: two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
source: endo-but-for-bots--llm-designs-unhandled-rejection-display
topics: [daemon, captp, errors]
status: current
title: The §don't-route-through-marshal — Alternative 1 rejected
parent: endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback
---

The most structurally interesting *Rejected Alternatives*
entry:

> *Rejected: the disconnect path runs precisely when the
> connection state is unreliable. The marshal tables may have
> been GC'd, the c-list may be partially torn down, or the
> disconnect may be happening because marshal itself failed.
> Adding a serialize step in the disconnect path adds another
> failure mode to the diagnostic. The Error-shape extraction
> is intentionally syntactic (no marshal, no exo machinery)
> so it cannot itself fail mid-disconnect.*

The §error-path-cannot-depend-on-error-path discipline: the
disconnect mechanism is itself error-reporting; routing it
through marshal would create a *circular failure mode*: if
marshal itself broke (causing the disconnect), routing the
disconnect through marshal would *re-trigger* the same
failure.

The §extraction-is-intentionally-syntactic move: read three
non-enumerable fields directly via destructuring. No method
dispatch, no proxy traps, no table lookups, no exo invocation.
*Purely syntactic*. Cannot fail.

This is the cycle's most generalizable insight: **diagnostic
paths must not depend on the substrate they diagnose**. The
parallel to cycle 100's `unhandled-rejection.js` (SES's
GC-driven rejection tracker that *doesn't* depend on the
console it would normally write to) is direct.
