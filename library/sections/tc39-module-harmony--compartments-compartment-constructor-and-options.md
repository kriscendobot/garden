---
title: Compartments layer 4 — `Compartment` class constructor and options (resolveHook, loadHook)
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

Abstract: The **`Compartment`** class as implementable in user code — its constructor accepts `resolveHook(importSpecifier, referrerSpecifier) → fullSpecifier`, `loadHook(fullSpecifier) → { source | record | namespace }`, and `globals` options. Internally it manages four maps (`#modules`, `#descriptors`, `#referrers`, `#globalThis`) and an `Evaluators` instance whose global references back to the compartment's `#globalThis`. The constructor copies `eval`, `Function`, `Module` into `#globalThis`, then overlays user-supplied globals.

## User Code

Compartments can be implemented in user code. This is a partial and untested sketch.

```js
class Compartment {
  #modules = new Map();
  #descriptors = new Map();
  #referrers = new Map();
  #globalThis = Object.create(null);

  constructor({ resolveHook, loadHook, globals }) {
    this.#resolveHook = resolveHook;
    this.#loadHook = loadHook;
    this.#importHook = async (importSpecifier, importMeta) => {
      const referrerSpecifier = this.#referrers.get(importMeta);
      const fullSpecifier = this.#resolveHook(
        importSpecifier,
        referrerSpecifier
      );
      return this.#load(fullSpecifier);
    };
    this.#evaluators = new Evaluators({
      globalThis: this.#globalThis,
      importHook: this.#importHook
    });
    // Copy eval, Function, and Module into the associated globalThis.
    Object.assign(this.#globalThis, this.#evaluators);
    Object.assign(this.#globalThis, globals);
  }

  get globalThis() {
    return this.#globalThis;
  }

  evaluate(script) {
    return this.#evaluators.eval(script);
  }

  async #descriptor(specifier) {
    let eventualDescriptor = this.#descriptors.get(specifier);
    if (!eventualDescriptor) {
      eventualDescriptor = this.#loadHook(specifier);
      this.#descriptors.set(specifier, eventualDescriptor);
    }
    return eventualDescriptor;
  }

  async load() {
    // ... implementation details follow in subsequent sections
  }
}
```

The constructor options are:

- **`resolveHook(importSpecifier, referrerSpecifier) → string`** — called on each import to resolve a (possibly-relative) specifier into an absolute full specifier. Receives the referrer's `import.meta.url` as context.
- **`loadHook(fullSpecifier)` — `Promise<{source} | {record} | {namespace}>`** — given the full specifier, returns either a virtual `ModuleSource`, a `ModuleDescriptor`, or a ready-made namespace. Determines whether the compartment loads from source (compiling it) or uses precompiled data.
- **`globals`** — an object of properties to overlay on top of the evaluators' exported `eval`, `Function`, and `Module`.

The compartment internally maintains:

- `#modules` — a map of loaded module instances keyed by specifier
- `#descriptors` — a memoized cache of loadHook results (promises) keyed by specifier  
- `#referrers` — a reverse-map from `import.meta` objects back to their referrer specifiers
- `#globalThis` — the compartment's global object, starting as `Object.create(null)` and populated with evaluators + user globals

[ses]: https://github.com/endojs/endo/tree/master/packages/ses
