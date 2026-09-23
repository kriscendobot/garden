---
title: Reference — Semantics (per-operator observation behavior)
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The semantic specification of each operator and operand. Soft-overlaps the operator-tutorial sections (which teach each operator by example); this section is the normative per-node behavior, including the binder-side (left-hand-side) semantics that the tutorials do not state in one place.
---

> Abstract: The normative semantics of FRB's query language: an expression is observed with a source value and emits a target one or more times, always emitting an initial value; array targets update incrementally, scalars re-emit on change, and any `null`/`undefined` operand suppresses the update so an invalid source never corrupts its target (it waits for a valid replacement). The section gives observation rules per operand (value, parameters, literal, `#` element, `@` component) and per operator (map/filter/some/every/sorted/sortedSet/min/max/group blocks; flatten/reversed/enumerate/view/sum/average/has/tuple; string startsWith/endsWith/contains/join/split; range/keys/values/entries; unary number/neg/not; binary arithmetic, comparison, equals, and/or; the `if` ternary). It then gives the **binder** (left-hand-side) semantics that differ from the read side: the last term of a binding target gets alternate behavior for `property`, `get` (collection `set`), `equals` (assign-on-true), `reversed`, `has` (add/remove on the collection), and `if`. A trailing `.*` on a target binds the target's content rather than the property.

### General

An expression is observed with a source value and emits a target one or more times. All expressions emit an initial value. Array targets are always updated incrementally. Numbers and booleans are emitted anew each time their value changes.

If any operand is `null` or `undefined`, a binding will not emit an update. Thus, if a binding's source becomes invalid, it does not corrupt its target but waits until a valid replacement becomes available.

### Operands and the read side

- Literals are interpreted as their corresponding value. Value terms provide the source. Parameters terms provide the parameters.
- In a path-expression, the first term is evaluated with the source value; each subsequent term uses the target of the previous as its source.
- A property-expression or variable-property-expression observes the key of the source object using `Object.addPropertyChangeListener`.
- An element identifier (`#` prefix) uses `parameters.document` and emits `document.getElementById(id)`, or dies trying; changes to the document are not observed. A component label (`@` prefix) uses `parameters.serialization` and emits `serialization.getObjectForLabel(label)`, or dies trying; changes to the serialization are not observed. This syntax exists to support Montage serializations.
- A "map" block observes the source array and emits a target array, emitted once with subsequent updates reflected as observable content changes; each target element is the observed value of the block expression over the respective source element. A "map" function call receives a function as its argument rather than a block.
- A "filter" block emits a target array containing only the source values that actively pass the block predicate, updated incrementally like map.
- A "some" block observes whether any value in the source meets the criterion; an "every" block observes whether all do.
- A "sorted" block observes the sorted array by a property of each value (or itself if empty), updated incrementally as values are added and deleted. A "sortedSet" block observes a range-change-emitting collection and emits a `SortedSet` exactly once; if the input is or becomes invalid the set is cleared, not replaced, and it always contains the last of each group of equivalent values.
- A "min"/"max" block observes which value in the collection produces the smallest/largest value through the given relation.
- A "group" block observes which values belong to corresponding equivalence classes determined by the block expression; the observer adds and removes classes as they populate and depopulate, each class tracking its key and an array of member values (appended as discovered). Any function call with a block implies calling the function on the result of a "map" block.
- A "flatten" call observes a source array of inner arrays and emits the concatenation as a target array, emitted once with subsequent incremental splices. A "reversed" call emits the source array's elements in reverse, incrementally. An "enumerate" expression observes `[key, value]` pairs from an array, incrementally updated. A "view" call observes a sliding window from a start index (first argument) of a length (second argument) over any range-change collection.
- A "sum" call observes the numeric sum, recomputed incrementally from the smaller sums of spliced values added and removed; "average" works much like sum. A "has" call observes whether the source collection contains an observed value.
- A "tuple" expression emits a single target array whose elements are the respective inner expressions, each evaluated with the same source value as the outer expression.
- String calls: "startsWith"/"endsWith"/"contains" observe whether the left string starts-with/ends-with/contains the right. "join" observes the left array joined by the right delimiter (not incremental). "split" observes the left string split on the right delimiter (not incremental).
- A "range" call observes an array of the given length holding sequential numbers from zero, dispatching one range change each time the size changes. "keys"/"values"/"entries" observe an incrementally updated array of a map's keys / values / `[key, value]` pairs, maintained in insertion order.

### Operators

Unary: "number" coerces to a number, "neg" negates a number, "not" logically negates a boolean.

Binary: "add"/"sub"/"mul"/"div" arithmetic; "mod" is proper modulo (toward negative infinity, always non-negative for positive divisor); "rem" is the remainder toward zero (can be negative); "pow" raises left to the right; "root" takes the right-th root of the left; "log" the logarithm of left on base right. Comparisons "lt"/"le"/"gt"/"ge" use `Object.compare(left, right)` against zero; "compare" is `Object.compare(left, right)`; "equals" is `Object.equals(left, right)`. There is no "not equals" node: `!=` becomes a "not" around an "equals". "and" and "or" are logical.

Ternary: "if" observes the condition; when true the result observes the consequent, when false the alternate, and when null/undefined the result is null/undefined.

### The binder side (left-hand side of a binding)

On the left hand side of a binding, the last term has alternate semantics; binders receive a target as well as a source.

- A "property" observes an object and property name from the target and a value from the source, updating the property when any change.
- A "get" observes a collection and key from the target and a value from the source, updating via `collection.set(key, value)` (suitable for arrays and custom map collections).
- An "equals" observes a boolean from the source; when it becomes true the equality is made true by assigning the right expression to the left property (turning "equals" into an "assign" conceptually); no action on false.
- A "reversed" observes an indexed collection and maintains a mirror array of it.
- A "has" observes a boolean from the source and a collection and sought value from the target; when true and absent it `add`s the value, when false and present it `delete`s/`remove`s all occurrences.
- An "if" binding observes the condition and binds the target to the consequent or alternate; if the condition is null/undefined the target is not bound.

If the target expression ends with `.*`, the content of the target is bound instead of the property. This is useful for binding the content of a non-array collection to the content of another indexed collection. The collection can be any that implements the observable-content interface (`dispatchContentChange(plus, minus, index)`, `addContentChangeListener`, `removeContentChangeListener`).

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
