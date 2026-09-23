---
title: §`harden(isPromise)` immediately after declaration
source-slug: endo--packages-promise-kit-src-is-promise-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/is-promise.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/is-promise.js
total-lines: 12
ingest-cycle: 252
ingest-date: 2026-06-09
lane: chat
parent: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines
---

```js
harden(isPromise);
```

§The-SES-convention-per-the-Endo-CLAUDE.md: *Every named export MUST have a corresponding `harden(exportName)` call immediately after the declaration*. §This-is-enforced-by-the-`@endo/harden-exports`-ESLint-rule.

§The-`harden(isPromise)` call freezes the function deeply + §prevents the function from being mutated by an attacker. §First-explicit-observation in library of §harden-immediately-after-export-as-named-SES-discipline (as a borrowable pattern, distinct from prior mentions where it was incidental).

§Sibling-pattern-to-cycle-247's-`const q = JSON.stringify;` — §two-cycles-with-immediate-post-declaration-treatment: §cycle-247-aliases-a-built-in-immediately + §cycle-252-hardens-an-export-immediately. §Two-different-shapes-of-immediate-post-declaration-step.
