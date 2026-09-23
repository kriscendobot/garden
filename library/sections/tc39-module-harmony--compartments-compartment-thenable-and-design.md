---
title: Compartments layer 4 — thenable module hazard and design questions (user code vs native)
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

Abstract: The **thenable module hazard** — an exported value named `then` confuses dynamic `import()` with promise resolution, causing it to return the resolved value rather than a namespace object. Also covers the design question of whether Compartments should be implemented in native code or user code, with arguments for each approach.

## Thenable Module Hazard

An exported value named `then` can be statically imported, but dynamic import confuses the module namespace for a thenable object. The resolution of the promise returned by dynamic import is the eventual resolution of the thenable module. And the eventual resolution is unlikely to be an intended effect.

Consider `thenable.js`:

```js
export function then(resolve) {
  resolve(42);
}
```

A neighboring module might dynamically import this:

```js
import('./thenable.js').then((x) => {
  // x will be 42 in this case, not a module namespace object with a then function.
});
```

This is the behavior of dynamic import today, despite it being surprising.

The Compartments proposal **embraces** this hazard since it would be worse to have dynamic import and compartment import behave differently. However, with `compartment.importNow`, a program can mitigate this hazard:

```js
await compartment.load('./thenable.js');
const thenableNamespace = compartment.importNow('./thenable.js');
// With importNow, the `then` function is NOT invoked — importNow returns the namespace directly.
```

With `importNow`, the module loads synchronously (if already linked) and returns the namespace object without invoking any `then` method. This is the recommended pattern for code that cannot control export naming.

## Design Questions

### User Code or Native Code

There are some reasons to make native Compartments that are not fully addressed by the lower-level primitives out of which they can be implemented in user code:

1. **Performance** — A native implementation may be able to avoid reifying some intermediate objects, which may be important for embedded systems.
2. **Approachability** — A higher-level API will be more approachable to a more casual user.
3. **Bundler size** — The runtime for a bundler in a web page might be considerably lighter in terms of `Compartment` than it might be in terms of the constituent objects. Bundler runtimes need to be as small as possible to meet the needs of webpage delivery performance.

However, user-code implementability is also a core design requirement: Compartments must be constructible from the lower layers (ModuleSource + static analysis + virtual module sources + evaluators) without requiring engine changes, so that real-world shims (SES, LavaMoat) can iterate independently of the specification timeline.

[ses]: https://github.com/endojs/endo/tree/master/packages/ses
[lava-moat]: https://github.com/LavaMoat/LavaMoat
[browserify]: https://browserify.org/
[node-hmr]: https://github.com/nodejs/node/issues/40594
[webpack]: https://webpack.js.org/
