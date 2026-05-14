---
title: Direct vs. indirect eval expressions
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, compartments]
status: current
---

> Abstract: Edge case in JavaScript: direct eval (eval(code) in syntactically-direct position) and indirect eval (saved-reference eval, or eval used as expression result) have different semantics under SES. Direct eval is constrained by the surrounding lexical scope; indirect eval runs in the global scope. Affects how Compartments interpret evaluated code.

## Direct vs. indirect eval expressions

A *direct eval*, invoked as `eval(code)`, behaves as if `code` were expanded in place. The
evaluated code sees the same scope as the `eval` itself sees, so this `code` can reference `x`:

```js
function foo(code) {
  const x = 1;
  eval(code);
}
```

If you perform a direct eval, you cannot hide your internal authorities from the code being evaluated.

In contrast, an *indirect eval* only gets the global scope, not the local scope. In a hardened
environment, indirect eval is a useful and common tool. The evaluated code can only access global
objects, and those are all safe (and frozen). The only bad thing an indirect eval can do is consume
unbounded CPU or memory. Once you've evaluated the code, you can invoke it with arguments to give it
as many or as few authorities as you like.

The most common way to invoke an indirect eval is `(1,eval)(code)`.

The HardenedJS proposal does not change how direct and indirect eval work. However, the SES shim
cannot correctly emulate a direct eval. If it tried, it would perform an indirect eval.
This could be pretty confusing, because the evaluated code would not use objects from
the local scope as expected. Furthermore, in the future when HardenedJS is natively implemented
by JavaScript engines, the behavior would revert to direct eval, allowing access to
anything in scope.

To avoid this confusion and compatibility risk, the shim uses a regular expression to
reject code that looks like it is performing a direct eval. This regexp is not complete
(you can trick it into allowing a direct eval), but that’s safe because it really performs
an indirect eval. Our goal is just to guide people away from confusing and non-compliant
behaviors early in their development process.

This regexp falsely rejects occurrences inside static strings and comments.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
