---
created: 2026-06-23
updated: 2026-06-23
author: gardener
---

# Skill: no-function-keyword

The house-style rule for endo-family packages: do **not** use the
`function` keyword in package sources. Use arrow functions or
concise method syntax. The rule applies to every garden role that
authors JavaScript inside endo-family repos (`endojs/endo`,
`endojs/endo-but-for-bots`, and downstream forks of either):
builder, fixer, cleaner, weaver, and the jury seats that read for
syntax shape (stylist, purist).

The upstream house-style document is the canonical source of
truth and exception catalogue:

- On `endojs/endo-but-for-bots`: `docs/house-style/function-keyword.md`.
- AGENTS.md (and through it CLAUDE.md) links to it from the repo root.
- Codified per kriskowal's directive on PR `endojs/endo-but-for-bots#474`
  (2026-06-23): *"Dispatch a gardener to reinforce this house style
  going forward."*

This skill is the garden's pointer at that document plus the
panel-side conversion and review discipline. The exception
catalogue is intentionally not duplicated here; readers consult
the upstream doc for the live list (it accretes as new exception
categories arise).

## The rule

In endo-family package sources:

- **Use arrow functions** (`(...) => {}`) when the function does
  not use `this` and is never called with `new`.
- **Use concise method syntax** (`{ name(...) {} }`,
  `{ get name() {} }`, `{ set name(v) {} }`) when the function
  uses `this` (or `super`) but is never called with `new`.
- **Leave the `function` keyword in place** only for the
  legitimate-exception categories enumerated in
  `docs/house-style/function-keyword.md`.

The rule is not stylistic preference; it follows from four
hardened-JavaScript hazards (per the upstream rationale):

1. `function`-keyword functions have both `[[Construct]]` and
   `[[Call]]` behaviors. They can be called with `new` even when
   the author never intended a constructor.
2. They carry a `prototype` property pointing at an irrelevant
   prototype object.
3. Because of that extra object, `freeze` is **not** equivalent
   to `harden`. The prototype object remains mutable and leaves
   reachable mutable state behind a `freeze`-only barrier.
4. Function-keyword *declarations* additionally hoist out of the
   temporal dead zone. In an import cycle, one side of the cycle
   can observe the function as a value before its module's
   top-level code has run, masking initialization-order bugs.

Arrow functions have none of these. Concise methods have neither
`[[Construct]]` nor `prototype`, while still binding `this`.

## Scope

- **In scope.** All package source under `packages/<pkg>/src/`,
  `packages/<pkg>/lib/`, and `packages/<pkg>/index.js` in
  endo-family repos. New code and converted code follow this
  rule.
- **Out of scope by category.** The seven legitimate-exception
  categories enumerated in `docs/house-style/function-keyword.md`:
  constructor emulation, generator and async-generator function
  expressions, vendored or third-party-derived code,
  monkey-patches of prototype methods with named functions,
  sloppy-mode `this` detection, TypeScript assertion functions,
  module-init-time forward references, and vendored runtime
  template literals. The doc carries the per-site detail and the
  current canonical examples; consult it before adding a new
  exception.
- **Out of scope by repo.** Repos outside the endo family
  (Agoric-SDK packages outside the hardened-JavaScript runtime,
  Cosmos-SDK governance code, etc.) follow their own house style.
  The skill does not impose this rule on every repo the garden
  touches.
- **Test code.** Test files under `packages/<pkg>/test/` follow
  the same rule by default. Test fixtures that specifically
  exercise `function`-keyword behavior (e.g., testing what
  happens when a value is called with `new`) are legitimate
  exceptions; the test names the reason inline.

## Applying the rule

### For builders and fixers authoring new code

Default to arrow or concise-method syntax. Reach for the
`function` keyword only when the situation falls under one of
the seven legitimate-exception categories, and inline a
one-line comment naming the category:

```js
// Constructor emulation: PseudoTypedArray needs [[Construct]] and prototype.
export function PseudoTypedArray(buffer, byteOffset, length) {
  // ...
}
```

The comment is load-bearing for two reasons: it tells the next
reader why the exception is intentional, and it gives the panel
a citation to confirm the exception against the house-style doc.

### For builders and fixers converting existing code

When a `function`-keyword function appears in code the dispatch
touches, convert it unless it falls under an exception:

- **Arrow conversion**: `function foo(a, b) { ... }` becomes
  `const foo = (a, b) => { ... }`. Preserve arity and return
  value; verify the body does not use `this` or `arguments`.
- **Method conversion**: `obj.foo = function (a, b) { ... }`
  becomes `obj.foo = function foo(a, b) { ... }`-as-method when
  bound to an object literal: `const obj = { foo(a, b) { ... } }`.
- **Hoisting check**: if the converted function was declared
  with `function foo(...) {}` (a declaration, not an
  expression), verify no call site referenced `foo` before its
  textual position in the file. A `const` arrow puts the
  reference into TDZ; the conversion fails closed at runtime if
  the call order is wrong.
- **Net behavioral diff is zero.** Every conversion preserves
  arity, return value, and `this` binding. Hoisting changes are
  intentional but must not break call sites.

If the function falls under an exception, leave it and add the
naming-the-exception comment if it lacks one.

A wholesale "retire `function` keyword" sweep across a package
goes in its own PR (the reference shape is PR
`endojs/endo-but-for-bots#474`, with the design at
`docs/house-style/function-keyword.md` originating as
`designs/retire-function-keyword.md`). A drive-by conversion of
one or two functions inside an unrelated feature PR is fine when
the dispatch already touches the file. Cross-package sweeps
belong in their own PR.

### For cleaners writing new tests

The same rule applies. Tests under `packages/<pkg>/test/` use
arrow or method syntax. A test that specifically exercises
`function`-keyword behavior (constructor emulation, sloppy-mode
`this`, hoisting) names the reason inline.

### For the stylist and purist seats reviewing diffs

The stylist's syntax-shape lens flags new `function`-keyword
introductions in package sources. The purist's lens covers the
four-hazard rationale: the `[[Construct]]` and `prototype`
implications, the `freeze`-vs-`harden` non-equivalence, and the
side-channel-via-hoisting case. See each seat's role file for
the per-finding shape.

The cite for findings: `[rule: skills/no-function-keyword/SKILL.md]`
(this file) plus the upstream house-style doc when the panel can
reach the project worktree to cite the specific exception
category.

## Pitfalls

- **Self-named function expressions for stack traces.** A
  pattern like `const foo = function foo() { ... }` exists
  specifically to preserve `.name` for diagnostics. Concise
  method syntax inside an object literal (`{ foo() {} }`) also
  preserves `.name` without the `[[Construct]]` and `prototype`
  hazards; that is the preferred replacement. The `patches`
  object pattern in `packages/init/src/node-async-local-storage-patch.js`
  is the reference shape.
- **Generators have no arrow spelling.** `function*` and
  `async function*` expressions are kept under the
  generator-function-expression exception. The author still
  hardens the wrapping closure (not just freezes it), since the
  generator's `prototype` property leaves a mutable object
  behind.
- **Module-init forward references look like style violations.**
  When a function is referenced by name during module top-level
  evaluation before its declaration, a `const` arrow conversion
  puts the reference into TDZ. Leave the `function` declaration
  in place under the forward-references exception; the
  alternative (reordering the whole file) is a structural change
  the conversion sweep deliberately defers.
- **`new.target` and `arguments` survive the conversion.** A
  conversion that removes a body's use of `arguments` (replacing
  with rest parameters) or `new.target` (replacing with an
  explicit constructor check) is a behavior change, not a style
  change. The conversion-sweep PR keeps the behavior identical;
  refactoring `arguments` and `new.target` belongs in a separate
  change.
- **TypeScript assertion functions (`function assertX(...): asserts x is Y`)
  cannot become arrows** under the current TS checker without
  losing the narrowing. The assertion-function exception covers
  these; the file or block keeps the `function` declaration and
  documents why.

## Notes from the field

- _2026-06-23_: skill added. The 93-conversion-site sweep on
  `endojs/endo-but-for-bots#474` is the reference shape for a
  package-wide retirement. The maintainer's framing
  (2026-06-23T06:25:14Z on PR #474): the rule is now standing
  house style and the gardener encodes it into the role and
  juror context so future builder and fixer dispatches honor it
  without explicit instruction. The seven legitimate-exception
  categories are stable enough to delegate to the upstream doc;
  new exception categories accrete there, not in this skill.
