---
title: "The Kernel-E meta-interpreter: name spaces, eval, pattern matching, and object behavior"
source_kind: web
source_url: http://erights.org/elang/kernel/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/kernel/index.html
source_fetched_via: mirror
source_content_sha256: 2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, capability-security, eventual-send]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The executable-
  specification half of the Kernel-E reference: the four name spaces, the four
  indirections from a noun to the object it designates, the eval outcome model
  (success/failure/escape), the testMatch/mustMatch pattern-matching routine, and
  how an object expression's state-nouns become its captured state. The form
  catalogs are in the sibling expression-forms and pattern-forms-and-helpers
  sections.
---

## Abstract

This is the **executable semantics** of Kernel-E: how the meta-circular
interpreter actually runs a parse tree. It defines the four kinds of names
(keywords, nouns, verbs, behavior-names) and the **four indirections** that take a
variable name to the object it ultimately designates — static
nounExpr→pattern correspondence, lexical scope→slot lookup, slot→reference
mutable state, and reference→object designation (where a reference can be a near
or an *eventual* cross-machine capability). It defines `eval(expr, scope)` as
producing one of three **outcomes** — Success (a value plus a possibly-extended
scope), Failure (a thrown exception), or Escape (a non-local exit) — written as a
single function with a big `switch` over the expression forms so that enhanced
interpreters can be defined by incremental modification rather than by methods
scattered across node types. It defines the dual `testMatch(patt, scope,
specimen)` routine (returning a one-element array of the extended scope on success
or `null` on failure, with `mustMatch` as the throw-on-failure variant), and it
shows how an object expression captures its **state-nouns** (the nouns it uses
that are defined outside it) as the object's state. The slot indirection, the
near/eventual reference distinction, and the per-instance scope-as-state model are
the kernel-level roots of E's vat semantics and of Endo's later reference model.

## Name spaces

E has four kinds of names:

- **Keywords** are reserved by the grammar (and eventually by user-defined
  syntactic-extension macros). Each keyword is its own terminal type and is not an
  `Identifier`; some keywords are reserved for future use.
- **Nouns** are E's term for variable names (a way to *refer* to things). Every
  use-occurrence of a variable name is a `nounExpr`, corresponding to a defining
  occurrence (a `finalPattern` or `varPattern`) of the same name. The
  correspondence is **purely static**: in the kernel language the scope of a
  `finalPattern` / `varPattern` extends textually left-to-right from its
  definition to the matching close-curly, except where an inner definition of the
  same name shadows it. (E's sugar usually follows the same rule, with the for-
  loop, conditional-or, and quasi-literal pattern as exceptions.)
- **Verbs** are E's term for method/selector names (a way to request *actions*).
  The defining occurrence is in a method definition and the use-occurrence is in a
  call or send; the correspondence is many-to-many and not statically
  determinable.
- **Behavior-names** are the names in `object` and `plumbing` expressions; unlike
  anonymous closures they enable *upgrading* old instances to a newer version of
  the behavior. The non-upgradable, non-debuggable interpreter presented here
  **ignores** behavior names: without upgrade/debugging, `def foo { ... }` is
  equivalent to `def foo := def _ { ... }`, so `foo`'s only remaining significance
  is as a `finalPattern` / `varPattern`.

## The four indirections from a noun to an object

Evaluating a noun reaches the object it designates through four distinct
indirections:

1. **Static correspondence** — `nounExpr -> finalPattern or varPattern`. The
   statically analyzable link between a use-occurrence and its defining
   occurrence, following the left-to-right-to-close-curly rule. (The interpreter
   below relies less on this analyzability than it could, instead managing scopes
   so that run-time name/scope uniqueness exactly matches the static rule.)
2. **Lexical lookup** — `scope[identifier] -> slot`. A scope is an immutable
   mapping from names to **slots**. Each evaluation gets a distinct scope, so the
   same identifier often looks up a distinct slot; per-instance instance-variable
   storage, for example, is just a per-instance scope mapping names to slots. (E
   has no distinct notion of instance variables; that effect is an outcome of this
   semantics.)
3. **Mutable state** — `slot.get() -> reference` (reading a value) and
   `slot.put(expr)` (assignment). A noun use turns into a slot lookup followed by
   asking the slot for its current value; assignment is a slot lookup followed by
   asking the slot to change its value; a `slotExpr` (`&name`) skips this step and
   returns the slot itself. Variables can vary precisely because slots can change
   value over time. A primitive mutable slot type is available and is used by
   default in the expansion of the sugar, giving classic assignment side effects.
4. **Designation** — `reference -> object`. The value from step 3 is not the
   object itself but a **reference** (pointer, capability) to it. Because E is
   distributed, references carry more semantics than usual: an **eventual**
   reference can span machines, and has a restricted semantics reflecting the
   inescapable difficulties of distributed computing (partial failure). This is
   documented in the E Reference Mechanics.

## eval and its outcome model

In the Lambda Calculus, evaluation takes an expression and a scope and produces a
value. In E, `eval` similarly takes an expression and a scope, but produces an
**outcome**, one of three:

- **Success** — `eval` returns a pair of a resulting value and a resulting scope.
  The resulting scope is a superset of the input scope, possibly with further
  bindings.
- **Failure** — `eval` throws an object as the exception indicating the problem
  (see `catchExpr` and `finallyExpr`).
- **Escape** — a non-local exit (see `escapeExpr`).

Failure and escape are both forms of non-local exit. The meta-interpreter
**absorbs the call-return stack discipline**: returning successfully in the
interpreted language is represented by `eval` returning successfully, and a non-
local exit in the interpreted language is `eval` performing the same non-local
exit.

The natural object-oriented design would distribute `eval` into methods on each
parse-node type (the Java bootstrap interpreter does exactly this). But that has
the wrong extensibility property: the kernel definition is held fixed for long
periods while *enhanced* semantics (debugging, upgrade) are defined by enhancing
the interpreter, so multiple interpreters must co-exist and be derived by
incremental modification. So the interpreter is written as one function with a big
`switch`, each branch matching one expression form:

```
def eval(expr, scope) {
  switch (expr) {
    ...
    match e`...` {
      ...
    }
    ...
  }
}
```

## Pattern matching: testMatch and mustMatch

Where classical languages put defining occurrences of nouns only in parameter
lists (and a separate variable-declaration construct), E puts **patterns**
everywhere a name is bound; binding a name to an initial value is pattern-matching
the pattern against that value, and a plain `Identifier` pattern is the degenerate
common case. The matching routine `testMatch(patt, scope, specimen)` dispatches
(via E's `switch`) on the pattern type:

```
def testMatch(patt, scope, specimen) {
  switch (patt) {
    ...
    match e`...` {
      ...
    }
    ...
  }
}
```

It takes a pattern parse-tree, a scope to match in, and a run-time specimen value.
Outcomes:

- On a **successful** match, it returns a **one-element array** containing a scope
  derived from the input scope plus any bindings from the match.
- On an **unsuccessful** match, it returns `null`.
- Components of the match may perform a non-local exit (failure or escape), in
  which case `testMatch` is so exited.

Returning a one-element array on success (rather than the scope directly) lets the
interpreter use `matchBind` expressions to both test for success and bind the
result compactly. The **`mustMatch`** variant turns an unsuccessful match into a
failure rather than `null`, so a success can return the scope directly:

```
def mustMatch(patt, scope, specimen) {
  def [result] := testMatch(patt, scope, specimen)
  result
}
```

## Object behavior and state-nouns

An object is an encapsulated package of state and behavior. Objects are defined by
**object expressions**, of two kinds: **methodical** expressions (methodical
objects) and **plumbing** expressions (objects acting as message plumbing). An
object expression evaluates in a scope to an object that behaves as the expression
describes. The chapter's worked example: the full-E

```
def makePoint(x, y) :any {
  def self {
    to getX() :any { return x }
    to getY() :any { return y }
  }
  return self
}
```

expands into the Kernel-E

```
def Point {
  to run(x y) :any {
    def self {
      to getX() :any { return x }
      to getY() :any { return y }
    }
    return self
  }
}
```

In the surface program `Point` looks like a function; in the expansion it is
actually an object with a single `run` method taking two arguments. Kernel-E is a
**pure object language**: all values are objects and all inter-object interaction
(except equality) is purely message-sending. `run` is E's **default verb**: if a
verb is left out it is supplied as `run` in the expansion, so an apparent function
definition actually defines an object with a `run` method. (Zero-argument argument
lists may also be left out of both definition and call, but you may not leave out
both the verb and the argument list.)

Where does `self`'s state come from? `x` and `y` act like instance variables with
no special declaration: their scope extends from their definition to the close-
curly at the end of `run`, and the `self` object expression within that scope can
refer to their slots by name. So the **state-nouns** of an object expression are
the nouns used within it that statically correspond to definitions *outside* it.
An object expression evaluates in a scope to an object whose **state is the subset
of that scope containing the object expression's state-nouns**; when the object
receives a message it executes the corresponding `eMethod` or `matcher` in a scope
that is a child of this state.

## Source

Source: [elang/kernel/index.html](https://erights.github.io/erights-org-website/elang/kernel/index.html) (mirror of `http://erights.org/elang/kernel/index.html`), last modified 1998-10-03, content SHA-256 `2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4`, fetched via the erights.org GitHub Pages mirror.
