---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
title: The §four predicate-assertion pairs — one-line dispatch to passStyleOf
parent: endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
---

The first four exports are *one-line* dispatches to cycle
71's `passStyleOf`:

| Predicate | Assertion | passStyle string |
|-----------|-----------|------------------|
| `isCopyArray(arr)` | `assertCopyArray(arr, 'Alleged array')` | `'copyArray'` |
| `isByteArray(arr)` | `assertByteArray(arr, 'Alleged byteArray')` | `'byteArray'` |
| `isRecord(record)` | `assertRecord(record, 'Alleged record')` | `'copyRecord'` |
| `isRemotable(remotable)` | `assertRemotable(remotable, 'Alleged remotable')` | `'remotable'` |

The §one-line-dispatch-pattern: `passStyleOf(val) === '<style>'`
is the entire predicate body. Each assertion adds the standard
`Fail` template-literal with the rejected `passStyle` reported.

The §`Alleged X` default-name discipline: each assertion has
an `optNameOfX = 'Alleged X'` second parameter. The
§default-name-for-anonymous-throw idiom — the error message
says *Alleged record must be a pass-by-copy record* when the
caller didn't bother to name the parameter. The §`Alleged:`-
prefix-as-default-name parallel to cycle 136's `make-far.js`
*Alleged: Foo* iface convention (allegations are *unverified
claims*).
