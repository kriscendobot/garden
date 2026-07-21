---
title: Module Expressions — what a Module is, caching, and why bundling needs module declarations
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-module-expressions/main/README.md
source_content_sha256: 4b29381601d31c9ddb3eab19f8298b5d52b77c1ef934df18196ef41d0ece3697
source_authors: [Surma, Daniel Ehrenberg, Nicolò Ribaudo]
source_date: 2025-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony]
status: current
---

Abstract: The proposal's FAQ answers that fix its place in module harmony — a module expression evaluates to an instance of a new `Module` class (as function expressions evaluate to `Function`), this `Module` class is deliberately *very limited* and the **Compartments proposal is looking into expanding its capabilities**, module expressions are cached "like object literals" (each *evaluation* mints a fresh `Module`, but each such `Module` has one instance in the module map), and module expressions deliberately *cannot* solve inter-module-reference bundling — that is why the separate [module declarations] proposal exists. Primary evidence for the Compartments-extends-`Module` intersection edge in [[module-harmony-intersection-surface]].

## What is a Module?

A module expression evaluates to an instance of the new `Module` class, similarly to how function expressions evaluate to instances of the `Function` class. The `Module` class introduced by this proposal is very limited, but the [Compartments proposal] is looking into expanding its capabilities.

## Are module expressions cached?

It depends what you mean by "cached." Module expressions have the same behavior as object literals — each time a module block is evaluated, a new module block is created:

```js
const arr = new Array(2);
for (let i = 0; i < 2; i++) { arr[i] = module {}; }
console.assert(arr[0] !== arr[1]);
console.assert(await import(arr[0]) !== await import(arr[1]));
```

However, `Module` objects participate in the module map just like any other module, so every expression block can only ever have one instance (its namespace), unless it's structured cloned:

```js
const m1 = module{};
const m2 = m1;
console.assert(await import(m1) === await import(m2));
```

## Can module expressions help with bundling?

At first glance it looks like they could bundle simple independent modules. But in the *general* case modules need to refer to each other, and for that module expressions would need to close over variables, which they can't:

```js
const combinedModule = module {
  const { count } = await import(countModule);      // ReferenceError:
  const { uppercase } = await import(uppercaseModule); // can't close over these!
};
```

To address the bundling problem there is a separate [module declarations] proposal, where `module countModule { … }` named declarations can `import { count } from countModule` by name. (Module expressions only allow *anonymous* module blocks; named module *bundles* are the module-declarations / Web Bundles territory.)

## Relationship to Blöcks

[Blöcks] has been archived. Module expressions are a better fit: Blöcks tried to introduce a new type of function that could close over/capture values (a can of worms), whereas modules are well-explored and well-specified, can only reference the global scope and do imports, and already have a caching mechanism.

Source: [proposal-module-expressions/README.md](https://github.com/tc39/proposal-module-expressions/blob/main/README.md) at content sha256 `4b293816`. Stage-3 reviewers listed; retrieved 2026-07-21.
