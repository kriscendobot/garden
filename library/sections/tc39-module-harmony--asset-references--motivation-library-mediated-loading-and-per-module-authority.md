---
title: Asset References — motivation: library-mediated loading, the `require.resolve` gap, and per-module asset authority under SES
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-asset-references/master/README.md
source_content_sha256: d40d635e77e9c8b21f811167e89e0339f06b7da6db76fc758d50e8173091f843
source_authors: [Sebastian Markbåge]
source_date: 2021-01-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, capability-security]
status: current
---

Abstract: Why the proposal argues syntax is warranted rather than a library, and the six motivating cases it enumerates. The core argument is relativity: an asset specifier is relative to the *executing* module, so it cannot be built at library level (there is no way to expose the relevant information from an `import()` call) and passing that context to a library has to be ergonomic enough that people actually do it. The cases: handing loading responsibility to an external resource manager (retry, fallback, I/O error handling, connect-to-WiFi prompts, picking among available resources); CSS/image/font loading, which today goes through webpack's convention of `import`ing non-JavaScript files; the `require.resolve` / `require.resolveWeak` gap, which the proposal calls "a missing piece crying for standardization"; interacting with a host loader or realm registry (test whether a module is already fetched, clear a cache entry, implement hot reloading); typed specifiers, which let TypeScript or Flow track `AssetReference<Module<{bar: number}>>`; and packaging, where a static specifier tells a bundler a resource will be needed without forcing an eager load. The case with the most weight for the garden is **per-module asset authority**: the proposal explicitly frames asset references as the way to lock down asset access "in small sandboxed environments like SES", giving each module references it alone owns until it explicitly passes them along, so one shared loading library can serve two modules without granting either access to the other's assets.

## Why special syntax

> In this case special syntax is warranted because the specifier is relative to the module executing which causes two issues:
>
> - This can't be built at a library level since there is no way to expose the relevant info from an `import()` call. The syntax is needed for the same reasons it is needed for `import()`.
> - If you want to externalize the logic into a library by passing some context to it, it needs to be very ergonomic to actually pass that context from the module to that libary.

## Importing from another file: hand the load to a library

Looking at ECMAScript alone, the main use case is deferring when importing and reimporting happen, performed by an external library:

```js
import ResourceManager from "my-library/resource-manager";
asset utility from "utility";
export async function foo() {
  let u = await ResourceManager.load(utility);
  return u.bar();
}
```

This lets the external resource manager own the complex interactions that come with I/O: passing additional arguments or setting up the loading environment, handling I/O errors and falling back gracefully, retrying a failed fetch, displaying a UI that asks the user to connect to WiFi and retrying after a button click, and picking one of several possible resources depending on availability. All of this is possible with dynamic `import` today, but because those are scoped to a local file, much of the logic gets hoisted out into the calling function. First-class references let those loading behaviors be abstracted.

## CSS and image loading

Referring to images, CSS, and fonts from a JavaScript file is a common pattern with no standard mechanism, so conventions diverged. In [Webpack](https://webpack.js.org/guides/asset-management/) it is done by `import`ing them as if they were JavaScript modules, with per-type export conventions (CSS files insert into the document as a side effect; images and fonts export their URL as a string). The downside named: no custom control over when individual files load or how they are used differently in different modules.

With asset references, the web platform could accept them in [`URL.createObjectURL()`](https://w3c.github.io/FileAPI/#dfn-createObjectURL), so an asset works as a file with any web API, and libraries can control decoding, retry, and fallback:

```js
asset Logo from "./logo.gif";
async function loadLogo() {
  let img = document.createElement("img");
  img.src = URL.createObjectURL(Logo);
  return img;
}
```

## The `require.resolve` gap

Node.js resolves a specifier to a canonical file path. Bundlers adapted the mechanism (webpack has both `require.resolve` and `require.resolveWeak`) under static-tooling constraints that changed it: the return value is an opaque "module id" rather than a file path, and the specifier has to be an inline literal so the dependency graph can be resolved statically. Those IDs then interact with the module loader and cache at runtime, through `require.cache` and similar. The proposal's verdict:

> These use cases still require these environments to keep the local scoped `require` hack and pseudo-static string resolution even when people are mostly moving on to completely ECMAScript compatible modules approach. Other bundlers either doesn't have this mechanism or implement it slightly differently. It's a missing piece crying for standardization.

## Interacting with a loader or realm API

Where the host exposes its loader to user code, an asset reference can be used wherever a canonicalized name would be expected: to check the registry for whether a module record has already been fetched or initialized (used to conditionally import only what is already in progress, or to hold a UI back until it can initialize synchronously without a loading indicator), to clear a specific cache entry where the host allows it (useful in unit tests), and to implement hot reloading of individual modules linked to specific asset resources in development tooling.

## Static specifiers, packaging, typed specifiers

- **Static asset specifier.** Static specifiers are not strictly required at runtime in a browser, but bundlers will require them regardless; the choice is between a pseudo-standard and explicit syntax that makes the constraint clear.
- **Packaging.** A static specifier lets bundlers and packagers know a resource will be needed at some point without loading it eagerly, so they can replace the URL with something internal to the tool, bundle it into the same ECMAScript file or tar file, or stream it over HTTP/2.
- **Typed specifiers.** If an asset refers to a module, type systems such as Flow and TypeScript can associate a type with the static specifier, giving `AssetReference<Module<{bar: number}>>` and catching a wrong annotation on the awaited import. With an arbitrary string it becomes less precise what the reference means and when it can be tracked.
- **Changing scheduling priority.** Where the platform grows scheduling priorities, this API can be used to change the loading priority of a module.

## Locking down asset access per module

The paragraph that makes this proposal a capability-security artifact rather than only a bundler ergonomics one, quoted in full:

> When dealing with arbitrary URLs it is difficult to lock down access in small sandboxed environments like SES. By providing an idiomatic way to reference assets relative to a module, we provide a way to create references that are only owned by that module until explicitly passed along, e.g. to a loading library. That same loading library can be used by two modules without giving access to the same asset to both modules.

This is ordinary capability discipline stated in module-loading terms: the reference is the authority, it is granted per module by the module's own static text, and sharing is by explicit hand-off rather than by ambient name resolution. The per-statement fresh object from the semantics section (created "to avoid creating an implicit back channel") is what keeps the grants from being conflated.

Source: [proposal-asset-references/README.md](https://github.com/tc39/proposal-asset-references/blob/master/README.md) at content sha256 `d40d635e`. Stage 1 (2018-11); retrieved 2026-07-29.
