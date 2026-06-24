---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: The §external↔internal transpose
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The §`MessageBreakpoints` external JSON shape and the §
`BreakpointTable` internal shape differ in *index order*:

| Shape | Outer key | Inner key | Value |
|-------|-----------|-----------|-------|
| External (user-facing) | `tag` or `'*'` | `method` or `'*'` | countdown |
| Internal (lookup-fast) | `method` or `'*'` | `tag` or `'*'` | countdown |

The §setBreakpoints procedure transposes the external shape into
the internal one. The §rationale is in the §shouldBreakpoint flow:
on every method call, the tester knows `methodName` first and
`recipient` second; *method-keyed lookup* lets the common case (no
breakpoint matches this method) early-exit at the first table
indexing. The external shape is *human-organized* (group by
recipient class); the internal shape is *lookup-organized* (group
by method).

The transpose builds the internal table fresh on each
setBreakpoints call:

```js
const newBreakpointsTable = { __proto__: null };

for (const [tag, methodBPs] of entries(newBreakpoints)) {
  // ... validation ...
  for (const [methodName, count] of entries(methodBPs)) {
    // ... validation ...
    const classBPs = hasOwn(newBreakpointsTable, methodName)
      ? newBreakpointsTable[methodName]
      : (newBreakpointsTable[methodName] = {
          __proto__: null,
        });
    classBPs[tag] = count;
  }
}
```

The §`__proto__: null` discipline (twice — outer table and inner
class-BPs) ensures the lookup `breakpointsTable[methodName]`
returns *only own-key matches*, never accidental matches against
`Object.prototype` keys (e.g., `'constructor'`, `'toString'`).
