---
section: three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
source: endo--packages-eventual-send-src-message-breakpoints-js
topics: [eventual-send, errors]
status: current
title: The §shouldBreakpoint match flow
parent: endo--packages-eventual-send-src-message-breakpoints-js--three-axis-match-grammar-with-external-internal-transpose-and-countdown-semantics
---

The §shouldBreakpoint procedure is the structurally interesting
center of the file. The flow:

1. **No methodName → no breakpoint.** *TODO enable function
   breakpointing.* The current implementation only matches on
   method calls.

2. **Method lookup**: `classBPs = breakpointsTable[methodName] ||
   breakpointsTable['*']`. The §method-or-wildcard fallback —
   exact-name first, then wildcard.

3. **Class-BPs not configured for this method → no breakpoint.**

4. **Tag lookup with wildcard fallback**:
   ```js
   let tag = simplifyTag(recipient[Symbol.toStringTag]);
   let count = classBPs[tag];
   if (count === undefined) {
     tag = '*';
     count = classBPs[tag];
     if (count === undefined) {
       return false;
     }
   }
   ```

   *Exact tag first, then wildcard tag, then no breakpoint.*

5. **Always-breakpoint shortcuts**:
   - `count === '*'` → always breakpoint
   - `count === 0` → always breakpoint (the *countdown-exhausted*
     state)

6. **Decrement-and-skip**: positive integer → `classBPs[tag] =
   count - 1; return false`. The §in-place-decrement mutates the
   internal table; *next call to shouldBreakpoint sees the
   decremented count*.
