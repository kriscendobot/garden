---
title: Asset References — worked use cases: Node.js resource loading, React component loading, Deno compile-time asset caching
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-asset-references/master/README.md
source_content_sha256: d40d635e77e9c8b21f811167e89e0339f06b7da6db76fc758d50e8173091f843
source_authors: [Sebastian Markbåge]
source_date: 2021-01-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, node-packaging]
status: current
---

Abstract: The three worked use cases the proposal closes with, each showing the same shape: a static declaration of *what* is needed, handed to something else that decides *when and how* to obtain it. In Node.js an asset can be served without ever loading it into JavaScript memory, staying in the C++ implementation for stream management (`request.respondWith(new Response(Image))`). In React the recommended component reference becomes `asset MyOtherComponent from "other-component"` instead of a synchronous `import`, so the UI library chooses when loading happens, controls scheduling, passes global configuration such as authentication or cancellation, resolves synchronously when possible, clears cache entries, and retries on failure; the best that can be done today (`createWrapper(() => import("other-component"))`) is criticized because the specifier is not guaranteed static, there is no interop with the underlying cache or a synchronous resolve, and options cannot be threaded without more boilerplate, leaving `require.resolve` as the practical fallback. In Deno, remote third-party modules are fetched and cached at compile time by URL, but non-code assets cannot join the dependency graph and must be downloaded at runtime, which costs startup time and forces a net permission grant or an extra build step; a static `asset fooPlugin from "./plugins/foo.so";` lets remote modules declare relatively located non-code dependencies so they are fetched and cached at compile time like JavaScript and TypeScript modules.

## Node.js resource loading

> We expect this mechanism to be used to be able to load and return an asset by never loading it into JS memory but staying in the C++ implementation for stream management.

```js
asset Image from "myimage.jpg";

export handleRequest(request) {
  request.respondWith(new Response(Image));
}
```

## React module loading

Today a component is imported synchronously into its parent, which then passes the reference to `createElement`:

```js
import {createElement} from "react";
import MyOtherComponent from "other-component";

function MyComponent() {
  return createElement(MyOtherComponent, {
    some: "data"
  });
}
```

The recommended form under this proposal declares an asset reference instead of importing directly:

```js
import {createElement} from "react";
asset MyOtherComponent from "other-component";

function MyComponent() {
  return createElement(MyOtherComponent, {
    some: "data"
  });
}
```

> That way the UI library is free to choose when it's best to load a component, control its scheduling, pass global configuration options (such as authentication/cancelation), synchronously resolve it if available, clear its cache entry, retry it if it fails, etc.

The best available standard approach today is a wrapper around a dynamic import:

```js
import {createElement, createWrapper} from "react";
const MyOtherComponent = createWrapper(() => import("other-component"));
```

The proposal's objections to it: the string is not guaranteed to be static; while the framework can control loading and reloading, there is no way to interoperate with the underlying cache or to resolve an existing module synchronously; and there is no way to add authentication or other options. Threading options through (`createWrapper(options => import("other-component", options))`) is "a lot of boilerplate for something as common as importing, and it still doesn't provide all the capabilities needed", so with today's tooling it is unfortunately better to fall back to the nonstandard `require.resolve`.

## Deno resource caching

Remote third-party modules are imported with URLs and cached in the filesystem at compile time. Those modules cannot include non-code assets in the dependency graph, so such assets must be downloaded at runtime instead, which harms startup performance and requires granting net permission to the program, or else necessitates an extra build step. This proposal lets remote modules declare static dependencies on relatively located non-code assets, so they can be fetched and cached at compile time like JavaScript and TypeScript modules:

```ts
// This is a remote module at https://deno.land/x/foo@0.1.0/mod.ts.
// It depends on a plugin at https://deno.land/x/foo@0.1.0/plugins/foo.so.

asset fooPlugin from "./plugins/foo.so";

Deno.openPlugin(fooPlugin);

export function foo(): void {
  Deno.core.dispatch(Deno.core.ops()["op_foo"], argUi8);
}
```

Source: [proposal-asset-references/README.md](https://github.com/tc39/proposal-asset-references/blob/master/README.md) at content sha256 `d40d635e`. Stage 1 (2018-11); retrieved 2026-07-29.
