---
title: Open-world fallback — method observers and operator auto-registration
source: compile-observer.js
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The extension mechanism at the tail of compile-observer.js. Explains how FRB's query language admits arbitrary method names and every arithmetic operator without an exhaustive table — a mechanism the README does not describe.
---

> Abstract: FRB's observer compiler is open-world: it does not require every callable to appear in its dispatch table. Two mechanisms close the gap. First, inside `compile`, any node `type` not already in `compilers` is lazily given a maker via `Observers.makeMethodObserverMaker(syntax.type)` and cached, so an unrecognized `type` is treated as a **method call** of that name on the observed value (this is what lets `&someMethod()` and bare method tails work for collection methods FRB never special-cased). Second, after the table is defined, the module walks every export of the `operators` module and registers a `makeOperatorObserverMaker(Operators[name])` for any operator name not already a compiler, so `pow`, `add`, `equals`, `compare`, and the rest become observer nodes without per-operator table entries. A final line hand-patches `toString`, because `toString` is inherited non-enumerably from `Object.prototype` and would be skipped by the `Object.keys(Operators).forEach` walk: the author's comment calls this "a special Hell for non-enumerable inheritance." Together these make the set of expressible nodes the union of the explicit table, every operator, and every method name, rather than a closed list.

```javascript
// inside compile(), for any node type not handled as a leaf:
if (!compilers.hasOwnProperty(syntax.type)) {
    compilers[syntax.type] = Observers.makeMethodObserverMaker(syntax.type);   // type -> method call of that name
}
var argObservers = syntax.args.map(this.compile, this);
return compilers[syntax.type].apply(null, argObservers);
```

```javascript
var compilers = semantics.compilers;
Object.keys(Operators).forEach(function (name) {
    if (!compilers[name]) {
        compilers[name] = Observers.makeOperatorObserverMaker(Operators[name]);
    }
});

// a special Hell for non-enumerable inheritance
compilers.toString = Observers.makeOperatorObserverMaker(Operators.toString);
```

Why this matters and what it adds beyond the README:

- **It explains FRB's apparent open vocabulary.** The README lists a fixed-looking set of functions and operators, but the source shows the set is computed: the table is a fast path, and anything else falls through to a method observer. A query may call a collection method FRB never enumerated.
- **Operators are data, not code, here.** Arithmetic and comparison observers are generated from the `operators` module's exports through one generic `makeOperatorObserverMaker`, so adding an operator upstream is a one-line `operators.js` change, not a `compile-observer.js` edit. This is the structural reason the operator set in `operators.js`, `language.js`, and the grammar's `BINARY` table can stay in sync by construction rather than by hand.
- **The `toString` special case** is a genuine inheritance hazard: `Object.keys` enumerates only own-enumerable keys, and `toString` arrives non-enumerably from the prototype, so without the explicit final line `'foo' + x.toString()` style coercions would have no observer. The comment is the author flagging exactly that footgun.
- **Caching mutates the shared `compilers` table.** The lazy `makeMethodObserverMaker` assignment writes into the module-level `semantics.compilers`, so the first use of a given method name in any expression registers it process-wide. Benign here (the makers are pure), but worth noting as shared mutable state on the compiler.

Source: [compile-observer.js](https://github.com/kriskowal/frb/blob/2162ce7cb574f1b5aed1cf8118c1548de8b85d70/compile-observer.js) at commit `2162ce7c`.
