---
title: Memoization Safety (overview)
source: packages/memoize/docs/memoize.md
source_repo: endojs/endo
source_commit: 2df33f43ef398fd98201a08e4b939302c13939fe
source_date: 2026-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

> Abstract: Mark Miller's writeup on safe memoization under SES. Naive memoization breaks under SES (mutable cache as covert channel, capability identity assumptions). This document walks through the constraints and the safe pattern @endo/memoize implements.


# Memoization Safety

Let's examime the contingent safety properties of the `memoize` function
implemented by the `memoize.js` module, whose implementation at the time of
this writing is
```js
/**
 * @template {WeakKey} A
 * @template R
 * @param {(arg: A) => R} fn
 * @returns {(arg: A) => R}
 */
export const memoize = fn => {
  const memo = new WeakMap();
  const memoFn = arg => {
    if (memo.has(arg)) {
      const memoedResult = memo.get(arg);
      if (memoedResult === encapsulatedPumpkin) {
        throw new TypeError('no recursion through memoization with same arg');
      }
      return memoedResult;
    }
    memo.set(arg, encapsulatedPumpkin);
    let result;
    try {
      result = fn(arg);
    } catch (e) {
      memo.delete(arg);
      throw e;
    }
    memo.set(arg, result);
    return result;
  };
  return harden(memoFn);
};
harden(memoize);
```

By "contingent safety", we mean the safety guarantees that follow given that
certain requirements are met. Before we examine these, let's first understand
the non-contingent semantics of this code.


Source: [packages/memoize/docs/memoize.md](https://github.com/endojs/endo/blob/2df33f43ef398fd98201a08e4b939302c13939fe/packages/memoize/docs/memoize.md) at commit `2df33f43`.
