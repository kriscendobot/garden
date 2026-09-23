---
title: §the-named-cond-OR-reject-AND-reject-template-literal
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

The JSDoc's canonical idiom:

```js
cond || reject && reject`...`
```

**§the-named-cond-OR-reject-AND-reject-template-literal** — first-explicit-observation. The idiom is THREE-PART:

1. `cond` — the predicate; truthy means we're done
2. `||` — short-circuit if `cond` is falsy, proceed to check rejector
3. `reject && reject\`...\`` — if rejector is `false`, the `&&` short-circuits to `false`; if rejector is `Fail`, invoke as template literal tag with `...` arguments

**§the-named-three-step-evaluation-shown-in-JSDoc** — first-explicit-observation. The JSDoc walks through three explicit cases:

> If `cond` is truthy, that is the value of the expression.
> Else if `reject` is false, it is the value
> Otherwise, invoke `reject` just like you would invoke `Fail`, with the same template arguments.

The three-case enumeration MATCHES the binary-decision-tree of the idiom (truthy / falsy-and-silent / falsy-and-throwing). **§the-named-three-case-enumeration-tracks-binary-tree** — first-explicit-observation. Tier-3 framing: when prose explains a short-circuit expression, enumerate each leaf of the decision tree explicitly.

**§the-named-template-literal-tag-as-error-constructor** — first-explicit-observation. The idiom invokes `Fail` as a template literal tag: `Fail\`...\``. This is the canonical @endo error-construction syntax (cycle 87 named the `null.null` syntax for `makeTypeError`; cycle 340 names the `Fail\`...\`` syntax for the @endo/errors trio). **§two-shapes-of-error-construction-syntax** (cycle 87 `null.null` + cycle 340 `Fail\`...\``) — first-explicit-observation.
