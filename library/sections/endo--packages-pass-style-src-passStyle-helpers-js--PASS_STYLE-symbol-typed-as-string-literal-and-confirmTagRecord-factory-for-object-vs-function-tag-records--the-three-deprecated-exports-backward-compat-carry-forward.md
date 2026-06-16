---
section: PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
source: endo--packages-pass-style-src-passStyle-helpers-js
topics: [pass-style]
status: current
title: The §three deprecated exports — backward-compat carry-forward
parent: endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records
---

The file exports *three deprecated* names:

1. **`hasOwnPropertyOf = hasOwn`** — *@deprecated Use
   `Object.hasOwn` instead*. The §pass-through-deprecation
   discipline: still works; new code uses the standard.

2. **`isObject`** — *@deprecated use `!isPrimitive` instead*.
   The §double-negative-clarity-issue: `!isPrimitive` makes the
   asymmetry of the check visible at the call site.

3. **`assertChecker`** — *@deprecated Use `Fail` with confirm/
   reject pattern instead*. The §rejector-pattern-replaces-
   checker-pattern observation: the old `Checker` callback
   shape (which throws or returns true) has been replaced by
   the *rejector* pattern (a callback that *returns false* with
   a message, used in `&&` chains). Cycles 134, 138, 140 all
   use the rejector pattern; this file's older API is the
   *legacy entry point*.

The §carry-forward-with-deprecation discipline: the three names
stay exported for compatibility; the JSDoc marks them as
deprecated; new code uses the modern alternatives.
