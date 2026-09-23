---
title: §the-named-Rejector-IS-false-OR-Fail
source: endo--packages-errors-rejector-js
url: https://github.com/endojs/endo/blob/master/packages/errors/rejector.js
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/errors/rejector.js
total-lines: 23
ingest-cycle: 340
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-typedef-as-the-pattern-anchor
  - the-named-canonical-source-of-a-distributed-pattern
  - the-named-types-only-file
  - the-named-Rejector-as-typedef
  - the-named-Rejector-IS-false-OR-Fail
  - the-named-cond-OR-reject-AND-reject-template-literal
  - the-named-three-step-evaluation-shown-in-JSDoc
  - the-named-binary-choice-silent-vs-throwing
  - the-named-references-test-as-illustration
  - the-named-test-file-as-canonical-examples
  - the-named-import-for-typedef-only-with-named-lint-disable
  - the-named-twenty-three-line-types-only-file
  - the-named-streak-resumes-with-tenth-instance
  - the-named-pattern-citation-network-anchored-at-canonical-source
  - the-named-fifteenth-package-source-in-the-pivot
  - thirty-one-cycles-with-named-pivot-domain-stay
  - seventy-five-citation-arc-closures-in-pivot-now
parent: endo--packages-errors-rejector-js--canonical-typedef-as-the-pattern-anchor-of-the-distributed-Rejector-trio
---

The typedef:

```js
@typedef {false | typeof Fail} Rejector
```

**§the-named-Rejector-IS-false-OR-Fail** — first-explicit-observation. The Rejector type is a sum-type with two inhabitants:
- `false` — the **silent-reject** mode (don't throw)
- `typeof Fail` — the **throwing-reject** mode (throw via the Fail template literal tag)

**§the-named-binary-choice-silent-vs-throwing** — first-explicit-observation. The Rejector parameter is the discriminator between two modes: silent (used by `is*` predicates) and throwing (used by `assert*` assertions). The SAME function body can serve both modes; the Rejector argument switches behavior at the boundary.

Cycle 102's checkKey.js named the trio pattern (Confirm/Is/Assert); cycle 340 reveals the canonical typedef that *describes the Rejector parameter shape*. The trio pattern's machinery: a private `confirmX(val, rejector)` function takes a Rejector; `isX(val) = confirmX(val, false)` (silent); `assertX(val) = confirmX(val, Fail)` (throwing).

**§the-named-discriminator-type-as-mode-switch** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: when one function body needs to serve two modes (silent + throwing), pass a discriminator parameter whose type is a sum-type covering both modes; let the function body short-circuit on the discriminator value.
