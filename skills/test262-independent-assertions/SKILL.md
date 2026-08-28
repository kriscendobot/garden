---
created: 2026-08-28
updated: 2026-08-28
author: gardener
---

# Skill: test262-independent-assertions

When constructing a test262-format test that pins several independent
metadata facts about a surface (method names, `.length` values, accessor
shapes, `Symbol.toStringTag`, prototype-chain links), assert **each
metadatum on its own line** with its own `assert.sameValue` (or
`assert`/`assert.throws`) and a message that names the exact property.
Do **not** collect the facts into a single joined string (or array) and
compare the aggregate once.

## When to use

- A builder, fixer, or panel-juror writes or reviews a test262 test that
  checks more than one property/shape of an intrinsic or object. Common
  cases: `intrinsic-metadata.js` conformance tests, prototype method-table
  pins, `.name`/`.length` sweeps, `Symbol.toStringTag` and prototype-chain
  assertions.
- A panel finding flags an aggregate/joined assertion under code review.
  The fix is mechanical; the discipline becomes citable for the next
  reviewer.

## The rule

Each metadatum is an independent assertion. Instead of:

```js
var metadata = [
  WeakSetPrototype.add.name,
  WeakSetPrototype.add.length,
  WeakSetPrototype[Symbol.toStringTag],
  prototypeOf(WeakSetPrototype) === Object.prototype,
].join('|');
assert.sameValue(metadata, 'add|1|WeakSet|true', 'the method table … agree');
```

write:

```js
assert.sameValue(WeakSetPrototype.add.name, 'add', '%WeakSet.prototype%.add.name');
assert.sameValue(WeakSetPrototype.add.length, 1, '%WeakSet.prototype%.add.length');
assert.sameValue(
  WeakSetPrototype[Symbol.toStringTag],
  'WeakSet',
  '%WeakSet.prototype%[Symbol.toStringTag]',
);
assert.sameValue(
  prototypeOf(WeakSetPrototype),
  Object.prototype,
  '%WeakSet.prototype% chains directly to %Object.prototype%',
);
```

Note the last line: where the joined form compared a `=== Object.prototype`
**boolean**, the split form asserts the object **identity** directly — more
informative on failure. Prefer asserting the value itself over asserting a
boolean derived from it whenever the independent form allows.

## Why

A joined-string assertion fails opaquely: one drifted property produces a
whole-blob mismatch (`'add|1|WeakSet|true' !== 'add|1|WeakSet|false'`) and
the reader must diff two strings by eye to find which fact broke — worse
across hosts, where the whole point is to name the surface that diverged.
Independent assertions make the failure output name the exact property that
drifted, and each message is a grep target. Granularity costs a few lines
and buys precise failure attribution.

## Grounding

Maintainer directive on endojs/endo-but-for-bots#1078 (kriskowal, review
5051462897): "Please make each metadatum an independent assertion. Please
consider this a rule in general for test262 construction going forward."
The four `%Map/Set/WeakMap/WeakSet.prototype%` intrinsic-metadata tests were
split accordingly. Related: [test-title-spec-spelling](../test-title-spec-spelling/SKILL.md)
(spell named surfaces as the spec does) — the two disciplines co-apply to
test262 construction.
