---
title: "Synchronous Sameness: == , substitutability, and reflexivity"
source_kind: web
source_url: http://erights.org/elang/same-ref.html
source_effective_url: https://erights.github.io/erights-org-website/elang/same-ref.html
source_fetched_via: mirror
source_content_sha256: 95878351747c7ff30439056002718ed330ca2e723c13ca901e85e666cea382c0
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, pass-style]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The page is
  marked "written ahead of the implementation"; it is a specification of
  intended semantics, some examples shown in red as not-yet-running at the time.
  Ancestor of Endo's pass-style equality discipline.
---

## Abstract

E's notion of **synchronous sameness**: the binary operator `==`, pronounced
"Is `a` the same as `b`?", which asks whether two references are *known to be the
same at this moment*. Sameness is defined to honor **substitutability** — the
high-school-algebra rule that if `a == b`, then replacing any number of
occurrences of one with the other anywhere in the computation state yields an
equivalent system. This strong requirement is deliberately incompatible with the
object-oriented practice of asking one object whether it equals another (the
object might lie), so `==` is a primitive of the language, not a method the
target implements. The section also covers E's guarantee that `==` is
**reflexive** (even for `NaN`, unlike IEEE), the separate magnitude operator
`<=>` for IEEE-conformant comparison, and when scalars are the same.

## Substitutability is the definition

> If `a == b` (if `a` is the same as `b`) then if you take a system and
> magically replace any number of one with the other, the resulting system must
> be equivalent (mean the same thing) as the original system. Here *system*
> means computation state.

Because an object asked "are you equal to that?" could answer dishonestly, E
does not delegate `==` to the target object. Sameness is decided by the language
according to fixed rules (identity for objects with identity, contents for
objects without), so it cannot be subverted by an untrustworthy object. This is
the property that makes `==` safe to use as a map-key comparison in the presence
of mutually suspicious objects.

## Reflexivity (and why NaN is reflexive in E)

If `a` is in scope and **settled**, `a == a` is always true; mathematicians call
this reflexivity. (If `a` is not settled, `a == a` throws a
`NotSettledException`; it is never false.) E deliberately departs from IEEE here:

```
? def a := 0.0/0.0
# value: NaN
? a == a
# value: true
```

IEEE specifies `NaN == anything` is always false. Were E to adopt that and lose
reflexivity, a map keyed on a `NaN`-valued variable could not find its own
entry, because lookup tests whether the provided key is the same as a stored
key. E guarantees reflexivity so that map lookup is well defined regardless of
the key's value. For an IEEE-conformant numeric comparison, E offers the
separate operator `<=>` ("is the same magnitude as"), one of the magnitude
comparison operators (`<`, `<=`, `>=`, `>`, `<=>`). Unlike `==`, the magnitude
operators expand to message sends on the left operand, so `a <=> a` is `false`
for `NaN`.

## When scalars are the same

E has four scalar data types (`integer`, `float64`, `boolean`, `char`). Two
scalars are the same only if they are the *same type* and have the *same value*:

```
? 2 == 2        # true
? 2 == 3        # false
? 0 == 0.0      # false   (integer vs float64: different types)
? 'a' == 'a'.asInteger()   # false   (char vs integer)
```

Scalars are a kind of *selfless* object (see the companion section): they are the
same based only on their value, never on identity, because they have no identity.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| `==` (synchronous sameness) | the marshal / pass-style *equate* relation; `Object.is`-grade identity for remotables plus structural sameness for copy data |
| substitutability | the same invariant Endo's pass-invariant equality of Handles preserves across marshal round-trips |
| settled | a *fulfilled* (resolved, non-pending) promise; comparing an unsettled reference is disallowed |
| `<=>` magnitude comparison | ordinary JavaScript numeric comparison (`<`, `>`, IEEE `NaN` semantics) |

## Source

Source: [elang/same-ref.html](https://erights.github.io/erights-org-website/elang/same-ref.html) (mirror of `http://erights.org/elang/same-ref.html`), last modified 1998-10-03, content SHA-256 `95878351747c7ff30439056002718ed330ca2e723c13ca901e85e666cea382c0`, fetched via the erights.org GitHub Pages mirror.
