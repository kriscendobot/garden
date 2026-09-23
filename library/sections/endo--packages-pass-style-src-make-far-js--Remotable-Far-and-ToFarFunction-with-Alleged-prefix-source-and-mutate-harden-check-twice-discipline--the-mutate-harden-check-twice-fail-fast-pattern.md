---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: The §mutate-harden-check-twice fail-fast pattern
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

The §`Remotable(iface, props, remotable)` function's structural
core is the *mutate-harden-and-check-twice* pattern:

```js
const mutateHardenAndCheck = target => {
  setPrototypeOf(target, remotableProto);
  harden(target);
  assertCanBeRemotable(target);
};

// Fail fast: check a fresh remotable to see if our rules fit.
mutateHardenAndCheck({});

// Actually finish the new remotable.
mutateHardenAndCheck(remotable);
```

The §fail-fast-via-fresh-object discipline: *first* call
`mutateHardenAndCheck({})` with a *fresh empty object* to test if
the rules fit; *then* mutate the real remotable. The §reason: if
something is structurally wrong (e.g., `remotableProto` itself
fails validation), the failure surfaces on a *throwaway* object
before the caller's real remotable gets mutated.

This is the §dry-run-then-commit pattern. The fresh `{}` is
*equivalent* to the real `remotable` for the purposes of the
check; if the throwaway fails, the real one would too. The §cost
is one extra harden of an ephemeral object; the §benefit is *the
caller's remotable doesn't get mutated mid-failure*.
