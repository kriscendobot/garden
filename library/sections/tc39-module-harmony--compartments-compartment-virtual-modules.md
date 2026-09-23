---
title: Compartments layer 4 — virtual module sources (JSON loading, export aliases, reexports)
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

Abstract: Virtual module source patterns enabled by the `loadHook` return options — `{source}` (compile from text), `{record}` (descriptor with bindings + executor), and `{namespace}` (ready-made namespace). JSON loading via virtual sources demonstrates non-JavaScript linkage; export aliases show how the `as` keyword maps internal names to public bindings; and reexports illustrate a pattern where one virtual module transparently delegates to another's namespace without copying bindings.

## Inter-compartment Linkage

Modules loaded within a compartment can import from each other using relative specifiers, and cross-compartment linkage works by sharing `ModuleSource` records between compartments:

```js
const sourceA = new ModuleSource(`export const value = 42;`);
const instanceA = new Module(sourceA);

// Share the same ModuleSource with another compartment
const otherCompartment = new Compartment({ /* ... */ });
const instanceA2 = await import(instanceA, { shared: otherCompartment });
```

Cross-compartment imports use `ModuleSource` as the transport — both compartments receive separate `Module` instances (and thus separate namespace objects) that wrap the same underlying source record. This is the "one source → multiple namespaces" pattern critical to the module harmony intersection.

## Linking with a Virtual Module Source (JSON Example)

To support non-JavaScript languages, a compartment provides a `loadHook` that returns virtual module source implementations. This example virtual module source declares its bindings (equivalent to `export default` in this case) and provides an executor:

```js
const compartment = new Compartment({
  resolveHook(importSpecifier, referrerSpecifier) {
    return new URL(importSpecifier, referrerSpecifier).href;
  },
  async loadHook(fullSpecifier) {
    const response = await fetch(fullSpecifier);
    const text = await response.text();
    
    // All modules are JSON — virtual source with `default` binding.
    return {
      record: {
        bindings: [{ export: 'default' }],
        execute(env) {
          env.default = JSON.parse(text);
        }
      }
    };
  }
});

await compartment.import('https://example.com/example.json');
```

The `record` return option bypasses compilation entirely — the compartment receives a ready-made binding declaration and an executor function. The executor receives a module environment record (`env`) on which it sets exports. This pattern enables compiling any text-based format into a module without writing a custom loader.

A more elaborate version would switch on the response MIME type and account for import assertions (e.g., `{ assert { type: 'json' } }`).

## Export Aliases and Module Imports Namespace

This example contrasts the properties of module imports namespace and a module exports namespace when bindings contain aliases:

```js
const compartment = new Compartment({
  resolveHook(importSpecifier, referrerSpecifier) {
    return new URL(importSpecifier, referrerSpecifier).href;
  },
  loadHook(fullSpecifier) {
    const record = {
      bindings: [
        { export: 'internal', as: 'external' },
      ],
      execute(env) {
        env.internal = JSON.parse(source); // mapped to `external` on import
      }
    };
    return { record };
  }
});

const fullSpecifier = 'https://example.com/example.js';
await compartment.load();
const { external } = compartment.importNow(fullSpecifier);
//      ^----- (aliased from `internal`)
```

The `{ export: 'internal', as: 'external' }` binding tells the compartment to map the internal name `internal` to the public alias `external`. When a consuming module destructures `{ external }`, it receives the value that was set as `env.internal` — the name transformation happens at the namespace boundary, not in the executor.

## Virtual Module Source Reexports

This example illustrates how a virtual module source can simply reexport another module with no special logic in an executor:

```js
const compartment = new Compartment({
  resolveHook(specifier) {
    return specifier;
  },
  loadHook(specifier) {
    switch (specifier) {
    case 'alex':
      return { namespace: { a: 10, b: 20, c: 30 } };
    case 'blake':
      return { source: { bindings: { exportAllFrom: 'alex' } } };
    }
  }
});

const { a, b, c } = await compartment.import('blake');
```

The `blake` module reexports everything from `alex` via the `{ source: { bindings: { exportAllFrom: 'alex' } } }` pattern. The virtual module source declares `exportAllFrom: 'alex'` as its binding specification, and the compartment handles the delegation automatically — no executor code needed. This enables module aliasing and barrel patterns entirely within the loader interface.

[ses]: https://github.com/endojs/endo/tree/master/packages/ses
