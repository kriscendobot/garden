---
title: Compartments layer 0 — ModuleSource, Module instances, and the 1-1-1-1 relationship
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/0-module-and-module-source.md
source_content_sha256: e51cb06e5a048eb9ab6fcbadda8784c7975673bde1138de67a42fc43df8badbe
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The core model of the Compartments layer-0 explainer — a **`ModuleSource`** is the compiled result of module source text that *gives its holder no powers* and captures only what static analysis can infer (immutable, serializable, shareable across realms and agents of a cluster); a **`Module` instance** wraps a `ModuleSource` plus a handler and carries the lifecycle (unlinked → linked → evaluated), producing exactly one Module Namespace Exotic Object; and a `Module` has a **1-1-1-1** relationship with a Module Environment Record, a Module Source Record, and a Module Exports Namespace Exotic Object. Multiple `Module` instances can share one `ModuleSource` and produce *separate* namespaces — this is exactly the "a `ModuleSource` used as an opaque key to index a module instance" surface the fresh design keys on. Companion to `--virtual-import-hooks-and-referrer` and `--intersection-semantics-and-262-factoring`.

## ModuleSource

```ts
interface ModuleSource { constructor(source: string); }
```

A `ModuleSource` instance gives the holder no powers. It represents a compiled EcmaScript module and does not capture any information beyond what can be inferred from a module's source text; import specifiers cannot be interpreted without further information.

- `ModuleSource` does for modules what `eval` already does for scripts; CSP is expected to treat module sources similarly. A `ModuleSource` constructed from text has no associated origin, but can be constructed from vetted text ([W3C Trusted Types]) and host-defined import hooks may reveal sources vetted behind the scenes.
- Multiple `Module` instances can be constructed from a single `ModuleSource`, producing one exports namespace for each imported `Module` instance.
- The internal record of a `ModuleSource` is **immutable and serializable**; it can be shared without cost between realms of an agent or even agents of an agent cluster.

## Module instances

```ts
interface Module {
  constructor(source: ModuleSource, handler: ModuleHandler);
  readonly source?: ModuleSource;
}
```

A `Module` instance has an internal Module Record. Importing the module consistently produces the same Module Namespace Exotic Object. The module has a lifecycle; fresh instances have not been linked, initialized, or executed. Invoking dynamic `import()` on a `Module` instance ("the kicker") attempts to advance it and its transitive dependencies to their end state. `Module` constructors, like `Function` constructors, are bound to a realm and evaluate modules in their particular realm.

## Examples — kicker, idempotency, and reusing a ModuleSource

```js
// Import kicker: any dynamic import initializes, links, and evaluates.
const source = new ModuleSource(``);
const instance = new Module(source);
const namespace = await import(instance);

// Idempotency: same instance → same namespace.
const namespace2 = await import(instance);
namespace === namespace2; // true

// Reusing a ModuleSource: separate instances → separate namespaces.
const i1 = new Module(source), i2 = new Module(source);
i1 === i2;                             // false
(await import(i1)) === (await import(i2)); // false
```

## Design — the record hierarchy

A **Module Source Record** is an abstract class for immutable representations of a module's dependencies, bindings, initialization, and execution behavior. An **EcmaScript Module Source Record** is the concrete EcmaScript variant. `ModuleSource` is a constructor that accepts EcmaScript module source text and produces an object with a `[[ModuleSource]]` slot referring to such a record. Multiple `ModuleSource` instances can share a common Module Source Record (immutable → shareable across realms and agent clusters). A `Module` has a 1-1-1-1 relationship with a Module Environment Record, a Module Source Record, and a Module Exports Namespace Exotic Object.

Source: [proposal-compartments/0-module-and-module-source.md](https://github.com/tc39/proposal-compartments/blob/master/0-module-and-module-source.md) at content sha256 `e51cb06e`. Stage 1; retrieved 2026-07-21.
