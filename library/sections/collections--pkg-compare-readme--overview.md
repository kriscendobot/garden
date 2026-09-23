---
title: compare operator
source: packages/compare/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/compare` exports a deep, *polymorphic* comparison operator. `compare(left, right)` returns a number with the same relationship to zero as `left` has to `right` (for numbers, `left - right`; when magnitude is not meaningful it returns positive or negative Infinity). It traverses into arrays and delegates to a `compare` method on either argument if one exists, favoring the left side and inverting the result when the right defines the method. Core principle: every value is equal to itself, *including NaN* (`compare(NaN, NaN) === 0`), which deviates from IEEE-754 so arbitrary values can be totally ordered in collections. Boxed values (`new Number(10)`) are unboxed before comparing; reference cycles are not yet handled. An optional third argument supplies an alternate comparator for nested comparison.

This package exports a comparison operator that accepts arbitrary objects and performs a deep comparison, traversing into arrays as well as delegating to the `compare` method of either argument if one exists, favoring the left side.

A comparator returns a number that has the same relationship to zero as the left value has to the right. For numbers, subtracting the right from the left gives such a difference value, describing both the direction and magnitude of the difference. A comparator for which the magnitude is not meaningful returns positive or negative infinity.

As a core principle, every value is equal to itself, including NaN, making this suitable for ordering arbitrary values in collections. Boxed values like `new Number(10)` are always unboxed before comparing. This operator does not handle equivalent object graphs with reference cycles at this juncture.

```js
var compare = require("@collections/compare");
expect(compare(-1, 1)).toBe(-2);
expect(compare("abc", "abc")).toBe(0);
expect(compare(NaN, NaN)).toBe(0);
expect(compare("a", "b")).toBe(-Infinity);
```

The compare function accepts an alternate comparator for nested comparison as its optional third argument.

```js
function dontcare() { return 0; }
expect(compare([10], [20], dontcare)).toBe(0);
```

## Polymorphic operator

A *polymorphic operator* is a function that accepts an object as its first argument and varies its behavior depending on its type. Such an operator covers for types introduced by higher layers of architecture, yet defers to the eponymous method name of types defined later, rather than monkey-patching a method backward through the layers. The comparison operator delegates to the `compare` method of either the left or right value, favoring the left, if either implements `compare`; the result is inverted when the right value supplies the method.

```js
var fake = { compare: function () { return -1; } };
expect(compare(fake, null)).toBe(-1);
expect(compare(null, fake)).toBe(1);
```

(Originally copyright Montage Studio Inc., BSD 3-Clause.)

Source: [packages/compare/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/compare/README.md) at commit `4688abad`.
