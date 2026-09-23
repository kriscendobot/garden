---
title: The binder compiler — invertible roots and the binder table
source: compile-binder.js
source_repo: kriskowal/frb
source_commit: 5a0203b2eaac938c4e446e235381579b46105a37
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The source behind the README's "compileBinder visits the root node (which must be a property for now)" sentence. Shows the actual set of invertible roots, which is larger than just property, and the simple per-type cases.
---

> Abstract: `compile-binder.js` compiles the **left-hand side** of a binding: where the observer compiler asks "what value does this expression watch", the binder compiler asks "how do I write a value back through this expression". Its `semantics.compilers` table is deliberately small, holding only node types with a clear inverse: `property`, `get`, `has`, `only`, `rangeContent`, `mapContent`, `reversed`, `and`, `or`. The README says the root "must be a `property` at this time, but could conceivably be any function with a clear inverse like `map` and `reversed`"; the source shows the conceivable set is already partly real, since `reversed`, `rangeContent`, `mapContent`, `only`, and `has` are invertible binder roots today. The `compile(syntax)` method dispatches each node type, handling several special forms before the table: `default` unwraps to its first argument; a `literal` binds only if it is `null`/`undefined` (returning `Function.noop`) and otherwise throws `"Can't bind to literal"`; `defined` wraps a sub-binder; and any type neither special-cased nor in the table throws `"Can't compile binder for <type>"`. Unlike the observer compiler there is no open-world fallback: a binder must be explicitly invertible, which is the source-level enforcement of "not every expression is two-way bindable."

```javascript
compile.semantics = {

    compilers: {
        property: Binders.makePropertyBinder,
        get: Binders.makeGetBinder,
        has: Binders.makeHasBinder,
        only: Binders.makeOnlyBinder,
        rangeContent: Binders.makeRangeContentBinder,
        mapContent: Binders.makeMapContentBinder,
        reversed: Binders.makeReversedBinder,
        and: Binders.makeAndBinder,
        or: Binders.makeOrBinder
    },

    compile: function (syntax) {
        var compilers = this.compilers;
        if (syntax.type === "default") {
            return this.compile(syntax.args[0]);                       // a ?? b binds to a
        } else if (syntax.type === "literal") {
            if (syntax.value == null) return Function.noop;            // binding to null/undefined is a no-op
            else throw new Error("Can't bind to literal: " + syntax.value);
        }
        // ... equals / if / and / or / everyBlock / rangeContent handled in the sibling section ...
        else if (syntax.type === "defined") {
            var bindTarget = this.compile(syntax.args[0]);
            return Binders.makeDefinedBinder(bindTarget);
        } else if (compilers.hasOwnProperty(syntax.type)) {
            var argObservers = syntax.args.map(compileObserver, compileObserver.semantics);
            return compilers[syntax.type].apply(null, argObservers);
        } else {
            throw new Error("Can't compile binder for " + JSON.stringify(syntax.type));
        }
    }
};
```

The `rangeContent` root, which binds the *content* of a collection rather than replacing it, is the one case that tries to compile a target binder and tolerates failure:

```javascript
} else if (syntax.type === "rangeContent") {
    var observeTarget = compileObserver(syntax.args[0]);
    var bindTarget;
    try { bindTarget = this.compile(syntax.args[0]); }
    catch (exception) { bindTarget = Function.noop; }            // content-bind even when the target itself can't be replaced
    return Binders.makeRangeContentBinder(observeTarget, bindTarget);
}
```

What the source adds beyond the README:

- **The invertible set is enumerated and already broader than `property`.** A reader of the README would believe only property paths are two-way bindable; the table shows `reversed`, `rangeContent`, `mapContent`, `only`, `has`, `and`, `or` are too. This is the concrete answer to "which expressions can sit on the left of `<->`."
- **Non-invertible binding fails loudly.** The terminal `throw "Can't compile binder for ..."` is why a two-way binding to, say, a `sum` is a compile-time error rather than a silent one-way binding. The observer compiler never throws; the binder compiler is where the asymmetry is enforced.
- **`default` and null-`literal` give graceful degenerate binders.** `target ?? fallback` binds through `target`; binding to a `null` literal is a deliberate no-op rather than an error, which lets conditional expressions whose branch is `null` compile cleanly.
- **Binder args are compiled as observers.** For table-driven nodes the arguments are passed through `compileObserver` (`syntax.args.map(compileObserver, ...)`): a binder is a thin invertible shell whose inner terms are ordinary observers. The binder owns only the write direction; everything it reads it reads through the observer compiler.

Source: [compile-binder.js](https://github.com/kriskowal/frb/blob/5a0203b2eaac938c4e446e235381579b46105a37/compile-binder.js) at commit `5a0203b2`.
