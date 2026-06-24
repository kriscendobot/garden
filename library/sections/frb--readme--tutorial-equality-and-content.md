---
title: FRB tutorial — equality, array/map content, value and context
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
---

> Abstract: The equality, content-projection, and value/context subsections (Equals, Array and Map Content, Value, With Context Value). `==` (or `=`, interchangeable) binds whether two expressions are equal and can bind two-way (setting the equality true assigns the right operand to the left); `<=>` is a comparison operator using `Object.compare`. Arrays masquerade as both objects and maps, so values are reachable by property notation (`array.0`) or map notation (`array.get(1)`, which permits a variable index); `rangeContent()` and `mapContent()` bind the entire content of a collection by range or by mapping. An omitted value on either side of an operator implies the source value (`sorted{}`, `filter{!!}`, `.0`). A parenthesized expression after a path (`context.(a + b)`) evaluates in that path's context; array/object literals after a dot (`context.[a, b]`, `context.{key: a}`) need no parentheses.

**Equals.** Binds whether two expressions are equal; `=` and `==` are interchangeable because equality and assignment are unified in this language.

```javascript
bind(fruit, "equal", {"<-": "apples == oranges"});
```

Equality can bind both directions. Setting an equality true assigns the right operand to the left, which makes mutually-exclusive radio-button-style bindings natural.

```javascript
Bindings.defineBindings(component, {
    "orangeElement.checked": {"<->": "fruit == 'orange'"},
    "appleElement.checked":  {"<->": "fruit == 'apple'"}
});
component.orangeElement.checked = true; // component.fruit === "orange"
```

FRB also supports the comparison operator `<=>`, which uses `Object.compare` to decide how two operands sort relative to each other.

**Array and Map Content.** In JavaScript an array behaves both like an object (each index is a property) and like a map (index-to-value pairs); the [Collections][] package patches `Array` so arrays masquerade as maps. FRB reflects this duplicity:

```javascript
Bindings.defineBindings(object, {
    first:  {"<-": "array.0"},      // property notation
    second: {"<-": "array.get(1)"}  // map notation; permits a variable index
});
```

To distinguish a numeric property from a number literal, use a leading dot (`.0`); to distinguish a mapped index from an array literal, use an empty expression (`get(1)` vs `[1]`). `rangeContent()` binds all content by range (any collection implementing `splice` and `swap` can be a target); `mapContent()` binds all content by map changes, applying per-key adds and removes from source to target.

**Value.** An empty path implies the source value. An omitted operand likewise implies the source: `sorted{}` sorts by each value's own numeric value, `filter{!!}` filters falsy values, `filter{!(%2)}` keeps even values. This is also why `.0` reads the zeroth property (versus the literal `0`) and `()[0]` maps the zeroth key (versus the array literal `[0]`).

**With Context Value.** A parenthesized expression following a path evaluates in that path's context.

```javascript
Bindings.defineBinding(object, "sum", {"<-": "context.(a + b)"}); // a + b within context
```

Array and object literals after a dot need no parentheses: `context.[a, b]` builds `[10, 20]`; `context.{key: a, value: b}` builds `{key: 10, value: 20}`.

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
