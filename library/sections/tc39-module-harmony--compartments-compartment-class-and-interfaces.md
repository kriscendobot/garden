---
title: Compartments layer 4 — the `Compartment` class, constructor options, and module descriptor interface
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/4-compartment.md
source_content_sha256: da5681d6259013c31ff429d36e5256e2079761f994ca1a3a01187d3ba43e2e2
source_authors: [Mark S. Miller, Caridy Patiño, Patrick Soquet, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The high-level **`Compartment`** class — a user-code-constructible object that orchestrates evaluators (`eval`, `Function`, `Module`) and module loading within a single global scope. The constructor accepts an options object (`globals`, `endorsedBuiltins`, `resolveHook`, `loadHook`) enabling full virtualization of the host's module loader behavior. The `ModuleDescriptor` type captures a compiled source record plus per-compartment metadata; it is the "module descriptor" surface that upstream Stage-1 Compartments carries, which the fresh design has **abandoned** in favor of an opaque `ModuleSource` key — this section preserves the upstream surface for compatibility analysis (see [[module-harmony-intersection-surface]] §5).

## Synopsis

Compartments provide a high-level API for orchestrating modules and evaluators, such that programs and modules can be collectively isolated to a particular global scope. We expect that compartments will be used to isolate Node.js packages and import map scopes.

Agoric's [SES shim][ses-shim], Sujitech's [ahead-of-time-SES][AOT-SES] and Moddable's [XS][xs-compartments] are actively vetting this proposal as a shim and native implementation respectively (2022).

This proposal is a [SES Proposal][ses-proposal] milestone.

## Motivation

Many ECMAScript module behaviors are defined by the host. The language needs a mechanism to allow programs running on one host to fully emulate or virtualize the module loader behaviors of another host.

Module loader behaviors defined by hosts include:

* resolving a module import specifier to a full specifier,
* locating the source for a full module specifier,
* canonicalizing module specifiers that refer to the same module instance,
* populating the `import.meta` object.

For example, on the web we can expect a URL to be a suitable full module specifier, and for every module specifier to correspond to a URL. We can expect the canonicalized module specifier to be reflected as `import.meta.url`. In Node.js, we can also expect import specifiers that are not fully qualified URLs to receive special treatment. However, in Moddable's XS engine, we can expect a module specifier to resemble a UNIX file system path and not have a corresponding URL.

We can also expect to have only one module instance per canonical module specifier in a given Realm, and for `import(specifier)` to be idempotent for the lifetime of a Realm. Tools that require separate module memos are therefore compelled to create realms either using Node.js's [VM context][vm-context] or `<iframes>` and [content security policies][csp] rather than a lighter-weight mechanism, and consequently suffer identity discontinuties between instances from different realms.

### Sub-realm sandboxes

Two use cases drive this design:

* sub-realm sandboxes ([SES][ses] and [LavaMoat][lava-moat]) that virtualize evaluating guest modules and limit access to globals and built-in modules. This proposal prepares for the SES proposal to introduce `lockdown`, which isolates all evaluators, including `eval`, `Function`, and this `Compartment` module evaluator. That proposal will introduce the concern of per-compartment globals and hardened shared intrinsics.

Defining a module loader in the language also improves the language's ability to evolve. For example, a module loader interface that accounts for linking "virtual" modules that are not JavaScript facilitates easier experimentation with linkage against languages like WASM. For another, a module loader interface allows for user space experimentation with the notion of [import maps][import-map].

Defining a module loader in the language also provides valuable insight to the design of every language feature that touches upon modules, and every new module system feature adds uncertainty to the eventual inclusion of a module loader to the language.

One such insight is that module blocks will benefit from the notion of a module descriptor as defined by this proposal. Module blocks roughly correspond to compiled sources and are consequently not coupled to a particular host environment. A module descriptor is necessary to carry properties of a module not captured in the source, like the module referrer specifier and how to populate `import.meta`.

Additionally, having a module loader interface is a prerequisite for shimming built-in modules.

## Module Descriptor Interface

```ts
// A ModuleDescriptor captures a module source and per-compartment metadata.
type ModuleDescriptor = {
  record: ModuleSource,
  // ... additional per-compartment metadata
};
```

A `ModuleDescriptor` captures a module source (as a reusable `ModuleSource` record) plus per-compartment metadata. The module source captures static analysis of the `import` and `export` bindings and whether the source ever utters the keywords `import` or `import.meta`.

The compartment then asynchronously **loads** the shallow dependencies of the module and memoizes the promise for loading the module and its transitive dependencies. If the compartment **imports** the module, it generates and memoizes a module instance and executes the module. To execute the module, the compartment constructs an `importMeta` object with a null prototype, and if the descriptor has an `importMeta` property, copies own properties over.

The compartment memoizes a promise for the module exports namespace that is fulfilled at a time already defined in ECMAScript 262 for dynamic import.

[ses]: https://github.com/endojs/endo/tree/master/packages/ses
[lava-moat]: https://github.com/LavaMoat/LavaMoat
[import-map]: https://github.com/WICG/import-maps
[ses-proposal]: https://github.com/tc39/proposal-ses
[ses-shim]: https://github.com/endojs/endo/tree/master/packages/ses
[AOT-SES]: https://github.com/DimensionDev/aot-secure-ecmascript
[xs-compartments]: https://blog.moddable.com/blog/secureprivate/
[vm-context]: https://nodejs.org/api/vm.html#vm_vm_createcontext_contextobject_options
