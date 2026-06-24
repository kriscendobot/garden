---
title: Algebraic binders — equals, if, and/or via solve, everyBlock
source: compile-binder.js
source_repo: kriskowal/frb
source_commit: 5a0203b2eaac938c4e446e235381579b46105a37
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The special binder forms that rotate algebraically. Captures the use of algebra.js solve() to split an and/or target into a bindable half and an observable half — the mechanism behind the README's "automatic algebraic inversion" claim.
---

> Abstract: Four node types get bespoke binder construction in `compile-binder.js` because they bind by algebraic rearrangement rather than by a single inverse function. `equals` builds an equality binder from a left-binder and a right-observer (`a == b` two-way means: when either side changes, drive the other toward equality). `if` builds a conditional binder from an observed condition and two sub-binders. `and` and `or` are the interesting pair: each calls `solve(syntax.args[i], valueSyntax)` from `algebra.js` to **rotate** the operand into a `[bindableTarget, equivalentSourceExpression]` decomposition, then compiles a binder for the bindable half and observers for the rest, handing all six functions to `makeAndBinder` / `makeOrBinder`. `everyBlock` similarly solves its predicate against `trueSyntax` so the collection can be driven to satisfy the predicate. This is the source realization of the README tutorial's "automatic algebraic inversion": FRB inverts a binding target not with a giant inverse-rule table but by symbolically solving the target expression for the bindable variable, exactly as one solves an equation. The simplifiers in `algebra.js` (`!!x → x`, `"" + x → toString(x)`, De Morgan's `some{x} → !every{!x}`) reduce the target before rotation so fewer inverse rules are needed.

```javascript
var valueSyntax = {type: "value"};
var trueSyntax  = {type: "literal", value: true};

// inside compile(syntax):
} else if (syntax.type === "equals") {
    var bindLeft    = this.compile(syntax.args[0]);
    var observeRight = compileObserver(syntax.args[1]);
    return Binders.makeEqualityBinder(bindLeft, observeRight);

} else if (syntax.type === "if") {
    var observeCondition = compileObserver(syntax.args[0]);
    var bindConsequent   = this.compile(syntax.args[1]);
    var bindAlternate    = this.compile(syntax.args[2]);
    return Binders.makeConditionalBinder(observeCondition, bindConsequent, bindAlternate);

} else if (syntax.type === "and" || syntax.type === "or") {
    var leftArgs  = solve(syntax.args[0], valueSyntax);   // [bindableTarget, equivalentSource]
    var rightArgs = solve(syntax.args[1], valueSyntax);
    var bindLeft  = this.compile(leftArgs[0]);
    var bindRight = this.compile(rightArgs[0]);
    var observeLeftBind  = compileObserver(leftArgs[1]);
    var observeRightBind = compileObserver(rightArgs[1]);
    var observeLeft  = compileObserver(syntax.args[0]);
    var observeRight = compileObserver(syntax.args[1]);
    return this.compilers[syntax.type](
        bindLeft, bindRight,
        observeLeft, observeRight,
        observeLeftBind, observeRightBind
    );

} else if (syntax.type === "everyBlock") {
    var observeCollection = compileObserver(syntax.args[0]);
    var args = solve(syntax.args[1], trueSyntax);          // drive the predicate toward true
    var bindCondition = this.compile(args[0]);
    var observeValue  = compileObserver(args[1]);
    return Binders.makeEveryBlockBinder(observeCollection, bindCondition, observeValue);
}
```

`solve` (from `algebra.js`) is the engine of the rotation: it repeatedly simplifies the target, then while the target's head type has a registered solver, rotates one term across to the source side and descends into the target's first argument, returning `[reducedTarget, equivalentSource]`.

```javascript
function solve(target, source) { return solve.semantics.solve(target, source); }
solve.semantics = {
    solve: function (target, source) {
        while (true) {
            while (this.simplifiers.hasOwnProperty(target.type)) {
                var simplification = this.simplifiers[target.type](target);
                if (simplification) target = simplification; else break;
            }
            if (!this.solvers.hasOwnProperty(target.type)) break;
            source = this.solvers[target.type](target, source);   // rotate a term to the source
            target = target.args[0];                              // descend
        }
        return [target, source];
    },
    simplifiers: { /* !!x->x ; ""+x->toString(x) ; some{x}->!every{!x} (De Morgan) ; ... */ }
};
```

What the source adds beyond the README:

- **"Automatic algebraic inversion" is literal symbolic algebra.** The README tutorial uses the phrase; the source shows a `solve` routine with `simplifiers` and `solvers` that rearranges the target expression to isolate the bindable variable, mirroring solving `y = f(x)` for `x`. This is the substantive mechanism behind a claim the README states without explaining.
- **`some` is implemented as `!every!`.** A De Morgan simplifier rewrites `some{x}` to `!every{!x}`, so only `every` needs a binder; `some`, `filter`-adjacent predicates, and negations collapse onto it. This is why `everyBlock` (not `someBlock`) is the predicate binder that appears here.
- **Each `and`/`or` binder receives six functions.** Two binders (left, right bindable halves), two plain observers (left, right operand values), and two solved-source observers. The pair `makeAndBinder` / `makeOrBinder` uses these to keep both operands consistent under a two-way boolean binding, which is more machinery than the README's one-line mention of two-way boolean bindings suggests.
- **`equals` binds left, observes right.** A two-way `a == b` is asymmetric in construction: the left operand is the writable target (compiled as a binder), the right is the reference value (compiled as an observer). The symmetry the user perceives is produced by the binding pairing two such constructions, not by `equals` itself.

Source: [compile-binder.js](https://github.com/kriskowal/frb/blob/5a0203b2eaac938c4e446e235381579b46105a37/compile-binder.js) at commit `5a0203b2`. The `solve` excerpt is from [algebra.js](https://github.com/kriskowal/frb/blob/5a0203b2eaac938c4e446e235381579b46105a37/algebra.js) (same repository), shown for context.
