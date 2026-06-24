---
title: The observer compiler — dispatch table and syntax-tree visitor
source: compile-observer.js
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The source behind the README's "compileObserver visits the syntax tree and creates functions for each node" sentence. Captures the full type→maker dispatch table and the leaf/record special-casing the prose omits.
---

> Abstract: `compile-observer.js` is the visitor that turns a parsed syntax tree into the root of the compiled observer function-tree. The README says only that it "visits the syntax tree and creates functions for each node"; the source is a ~50-entry dispatch table (`semantics.compilers`, mapping each node `type` to an `Observers.make*Observer` maker) plus a `compile(syntax)` method that branches on a handful of leaf types before consulting the table. The leaves handled before the table are `literal` (→ `makeLiteralObserver(value)`), `value` (→ `observeValue`), `parameters` (→ `observeParameters`), `element` (→ `makeElementObserver(id)`), `component` (→ `makeComponentObserver(label, syntax)`), and `record` (build an observers-object by recursively compiling each named arg, then `makeObjectObserver`). Every other node recurses on its `args` array (`syntax.args.map(this.compile, this)`) and applies the table's maker to the resulting child observers. Because compilation is recursive and bottom-up, the returned function **is** the tree: each maker closes over its compiled child observers, so the structure of the syntax tree becomes the structure of the live observer tree, which is the concrete realization of [[frb-compiled-observer-tree]].

```javascript
var semantics = compile.semantics = {

    compilers: {
        property: Observers.makePropertyObserver,
        get: Observers.makeGetObserver,
        path: Observers.makePathObserver,
        "with": Observers.makeWithObserver,
        "if": Observers.makeConditionalObserver,
        parent: Observers.makeParentObserver,
        not: Observers.makeNotObserver,
        and: Observers.makeAndObserver,  or: Observers.makeOrObserver,
        "default": Observers.makeDefaultObserver,  defined: Observers.makeDefinedObserver,
        rangeContent: Observers.makeAsArrayObserver,
        mapContent: Function.identity,                      // source-side: pass the collection through
        keys: Observers.makeKeysObserver,  values: Observers.makeValuesObserver,
        items: Observers.makeEntriesObserver, // XXX deprecated
        entries: Observers.makeEntriesObserver,
        toMap: Observers.makeToMapObserver,
        mapBlock: Observers.makeMapBlockObserver,  filterBlock: Observers.makeFilterBlockObserver,
        everyBlock: Observers.makeEveryBlockObserver,  someBlock: Observers.makeSomeBlockObserver,
        sortedBlock: Observers.makeSortedBlockObserver,  sortedSetBlock: Observers.makeSortedSetBlockObserver,
        groupBlock: Observers.makeGroupBlockObserver,  groupMapBlock: Observers.makeGroupMapBlockObserver,
        minBlock: Observers.makeMinBlockObserver,  maxBlock: Observers.makeMaxBlockObserver,
        enumerate: Observers.makeEnumerationObserver,  reversed: Observers.makeReversedObserver,
        flatten: Observers.makeFlattenObserver,  concat: Observers.makeConcatObserver,
        view: Observers.makeViewObserver,
        sum: Observers.makeSumObserver,  average: Observers.makeAverageObserver,
        last: Observers.makeLastObserver,  only: Observers.makeOnlyObserver,  has: Observers.makeHasObserver,
        // TODO zip
        tuple: Observers.makeArrayObserver,  range: Observers.makeRangeObserver,
        startsWith: Observers.makeStartsWithObserver,  endsWith: Observers.makeEndsWithObserver,
        contains: Observers.makeContainsObserver,  join: Observers.makeJoinObserver,
        toArray: Observers.makeToArrayObserver,
        asArray: Observers.makeToArrayObserver // XXX deprecated
    },

    compile: function (syntax) {
        var compilers = this.compilers;
        if (syntax.type === "literal")        return Observers.makeLiteralObserver(syntax.value);
        else if (syntax.type === "value")     return Observers.observeValue;
        else if (syntax.type === "parameters")return Observers.observeParameters;
        else if (syntax.type === "element")   return Observers.makeElementObserver(syntax.id);
        else if (syntax.type === "component") return Observers.makeComponentObserver(syntax.label, syntax);
        else if (syntax.type === "record") {
            var observers = {}, args = syntax.args;
            for (var name in args) observers[name] = this.compile(args[name]);
            return Observers.makeObjectObserver(observers);
        } else {
            if (!compilers.hasOwnProperty(syntax.type))            // open-world fallback; see sibling section
                compilers[syntax.type] = Observers.makeMethodObserverMaker(syntax.type);
            var argObservers = syntax.args.map(this.compile, this);
            return compilers[syntax.type].apply(null, argObservers);
        }
    }
};
```

What the source adds beyond the README:

- **The exact maker per node type.** The README's syntax-tree section names the node types but not which observer maker realizes each. This table is the missing half: `mapBlock`→`makeMapBlockObserver`, `sortedSet`→`makeSortedSetBlockObserver`, and so on.
- **`rangeContent` and `mapContent` are asymmetric.** On the observer (source) side, `rangeContent` compiles to `makeAsArrayObserver` and `mapContent` to `Function.identity` (pass the collection through). Their real work is on the binder side as target hints (see [frb--compile-binder--invertible-roots-and-binder-table](frb--compile-binder--invertible-roots-and-binder-table.md)), matching the README's "no effect on the source" note.
- **Deprecated aliases are live.** `items` aliases `entries` and `asArray` aliases `toArray`, both marked `// XXX deprecated` but still compiled, so old expressions keep working.
- **`record` builds an observers-object, not an array.** It is the one node whose children are keyed (matching the `record` args-object shape from [frb--grammar--literals-strings-numbers-records-tuples](frb--grammar--literals-strings-numbers-records-tuples.md)); `makeObjectObserver` reassembles a live object whose property values track their child observers.

Source: [compile-observer.js](https://github.com/kriskowal/frb/blob/2162ce7cb574f1b5aed1cf8118c1548de8b85d70/compile-observer.js) at commit `2162ce7c`.
