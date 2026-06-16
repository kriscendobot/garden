---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: The §already-frozen check via comparison-against-fresh
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

The §already-frozen guard:

```js
isFrozen(remotable) === isFrozen({})
  || Fail`Remotable ${remotable} is already frozen`;
```

The §inline comment names the rationale:

> *Recall that isFrozen always returns true when using lockdown
> with hardenTaming set to the deprecated `'unsafe'` option.*

Under `hardenTaming: 'unsafe'`, *every object's `isFrozen` returns
true* — so a direct `!isFrozen(remotable)` check would always
fail. The §comparison-against-fresh discipline: compare against
`isFrozen({})` so we check *relative* frozen-ness. Under safe
lockdown, `isFrozen({})` returns false and the check works
normally; under unsafe lockdown, both return true and the check
becomes vacuously equal (no check, but also no spurious
rejection).

The §pattern-for-detecting-environment-quirks discipline: don't
hard-code an expected return value; compare against a *fresh
control sample*.
