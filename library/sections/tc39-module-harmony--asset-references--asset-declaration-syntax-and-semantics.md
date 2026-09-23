---
title: Asset References — the `asset Foo from "foo"` declaration, its binding semantics, and `import(AssetReference)`
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-asset-references/master/README.md
source_content_sha256: d40d635e77e9c8b21f811167e89e0339f06b7da6db76fc758d50e8173091f843
source_authors: [Sebastian Markbåge]
source_date: 2021-01-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, module-loader]
status: current
---

Abstract: The syntax and semantics half of the Asset References proposal (Stage 1 since November 2018): a first-class, statically declared reference to a module's *identity* that does not load or initialize it. `asset Foo from "foo";` mirrors the `import` statement form but allows only the single-identifier form (no destructuring, no newline after `asset`), and creates a const binding initialized immediately with an empty object whose prototype is `AssetReference.prototype`. The specifier is conceptually resolved to the same canonical URL, file path, or identity it would have had under `import`, but resolution may be deferred (canonicalizing in Node.js is expensive disk work) and no load or initialization is triggered. The object carries two internal slots, `[ReferencingModule]` (the current module) and `[AssetSpecifier]` (the static specifier), and passing it to dynamic `import()` performs `HostImportModuleDynamically` with exactly those two. A fresh object is created per module statement specifically to avoid creating an implicit back channel. The referenced asset need not be a JavaScript module at all: it can be handed to a host loader to resolve to an image, CSS, font, or any other resource.

## Syntax

```js
asset Foo from "foo";
```

> This syntax mirrors the `import` statement form, but only allows the single identifier form (no destructuring). No newline after `asset`. It allows a static declaration of a weak dependency on an asset relative to this module.

That "asset" could be another ECMAScript module. Unlike `import`, the `asset` statement does not actually load the other module; it is just a reference to it. This reference can be passed to any dynamic `import` call to load it and asynchronously resolve it to a module instance:

```js
async function Bar() {
  let foo = await import(Foo);
}
```

An asset does not have to refer to an ECMAScript module. It can also be passed to an external loader that resolves it to an image, CSS, font, or any other resource the program needs.

## Semantics

The `asset` statement creates a **const binding** for the identifier's name. The module specifier conceptually gets resolved to the same canonical URL, file path, or identity it would have had if used in an `import`. It does not, however, trigger a load or initialization of that module if one has not happened elsewhere.

The binding is immediately initialized with an empty object whose prototype is `AssetReference.prototype`. Two properties of that initialization are load-bearing:

- **A new object is created for each module statement**, explicitly "to avoid creating an implicit back channel". Two modules referencing the same asset therefore hold distinct, non-comparable reference objects.
- It "allows an implementation to defer the actual canonical resolution until later", since in Node.js canonicalizing can be an expensive operation requiring disk access.

Internal slots: `[ReferencingModule]` is set to the current module, and `[AssetSpecifier]` is set to the static module specifier.

### `import(AssetReference)`

If an asset reference is passed to dynamic `import()`, the host performs `HostImportModuleDynamically` using the `[ReferencingModule]` and `[AssetSpecifier]` internal slots of that asset reference, so the module is loaded dynamically if it has not already been loaded.

The proposal notes a consequence worth keeping: "The asset reference doesn't have to come from the same module as the `import()` call is in. This lets a third module be the one to actually initiate the loading."

### `AssetReference`

`AssetReference` is a constructor that **throws if called**. `AssetReference.prototype` is an empty object with a `constructor` field set to `AssetReference`. It is effectively an opaque object at this point, but the proposal leaves room for ECMA-262 (or possibly the host environment) to expand it with methods or fields later.

### Loaders

An asset reference can also be passed into module loaders defined by the host environment to perform more advanced optimizations: synchronously testing whether it has been loaded, clearing it from the cache, and similar. The proposal deliberately does not define what loaders are allowed to do with an asset reference, expecting loader proposals to take advantage of it.

Source: [proposal-asset-references/README.md](https://github.com/tc39/proposal-asset-references/blob/master/README.md) at content sha256 `d40d635e`. Stage 1 (2018-11); retrieved 2026-07-29.
