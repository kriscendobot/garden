---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: The §hideAndHardenFunction vs harden
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

The §`hideAndHardenFunction` (vs `harden`) is structurally
worth noting:

- **`harden(fn)`** freezes the function and its prototype chain.
- **`hideAndHardenFunction(fn)`** does that *plus* sets the
  function's `name` and other metadata to be non-revealing.

The §rationale (from `@endo/errors`): when an assertion function
throws, its name appears in the stack trace. The hideAndHarden
variant prevents the function's name from being shown,
*reducing information leak* from the assertion's call site.

Cycle 134's `remotable.js` used `hideAndHardenFunction(assertIface)`
for the same reason — assertion functions hide their identity
from the stack trace.
