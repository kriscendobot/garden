---
title: Compartments layer 2 — the VirtualModuleSource protocol and how bindings link namespaces
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/2-virtual-module-source.md
source_content_sha256: ffd7fbc7ec72d75e4b377eb82b587bb0b05b88466b93e297fedb98c075fb858b
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: Compartments **layer 2** (`2-virtual-module-source.md`) extends the `Module` constructor to accept **virtual module sources** — plain objects (no `[[Module Source]]` internal slot) implementing a protocol sufficient to virtualize the evaluation of modules in languages ECMA-262 or a host did not anticipate. This is the loader-hook layer a minimal Compartments spec must decide whether to adopt: it lets *user code* (not just a host) integrate CommonJS, JSON, or WASM where the host does not. This section states the protocol interface (`bindings` / `execute` / `needsImport` / `needsImportMeta`), how the constructor recognizes a virtual source (an object lacking the `[[Module Source]]` slot), and the linkage rules by which each `Binding` shape wires this module's *Module Imports Namespace* to its and its dependencies' *Module Exports Namespace*. The JSON/CommonJS/WASM/pass-through examples are in `--virtualization-examples-json-cjs-wasm-passthrough`; the serializability invariant and transmission limits in `--serializability-and-transmission-limits`.

## The protocol

The first argument to the `Module` constructor is a source. **If that source is an object that does not have a `[[Module Source]]` internal slot**, it is treated as a protocol for loading, binding, linking, initializing, and executing the new `Module` instance:

```ts
type VirtualModuleSource = {
  // The import/export bindings between this module's environment record,
  // its namespace exotic object, and its dependencies.
  bindings?: Array<Binding>,

  // Executes the module when imported. May return a promise, indicating the
  // module uses the equivalent of top-level await.
  execute?: (namespace: ModuleImportsNamespace, {
    import?: (importSpecifier: string) => Promise<ModuleExportsNamespace>,
    importMeta?: Object,
    globalThis: Object,
  }) => void,

  // execute needs a dynamic import function bound to this Module instance.
  needsImport?: boolean,

  // execute needs an importMeta.
  needsImportMeta?: boolean,
};
```

`bindings` must use the shapes from layer 1 (module-source static analysis). The `Module` constructor from layer 0 extends to accept virtual module sources in place of a `ModuleSource`, and reflects whatever `source` it is given as the returned instance's `source` property.

## Binding linkage rules

For every `Module` with a virtual source, the machinery constructs a real **Module Imports Namespace**, an exotic object through which `execute` gets and sets each binding's value. Each `Binding` shape links a name between this module's *Module Imports Namespace* (its inward view) and a *Module Exports Namespace* (its own or a dependency's):

| Binding | Linkage |
|---|---|
| `{ import, from }` | the named `import` property of this *Imports Namespace* ← same name of the `from` module's *Exports Namespace* |
| `{ import, as, from }` | the `as` property of this *Imports Namespace* ← the `import` name of the `from` module's *Exports Namespace* |
| `{ export }` | this module's `export` property of the *Imports Namespace* → directly to its *Exports Namespace* |
| `{ export, as }` | this module's `export` property of the *Imports Namespace* → the `as` property of its *Exports Namespace* |
| `{ export, as, from }` | the `export` name of the `from` module's *Exports Namespace* → the `as` property of this module's *Exports Namespace*, bypassing this module's *Imports Namespace* entirely |
| `{ importAllFrom, as }` | the whole *Exports Namespace* of `importAllFrom` → the `as` name in this module's *Imports Namespace* |
| `{ exportAllFrom }` | all names except `default` of `exportAllFrom` → this module's *Exports Namespace*, bypassing the *Imports Namespace* |
| `{ exportAllFrom, as }` | the *Exports Namespace* of `exportAllFrom` → an `as` property on this module's *Exports Namespace*, bypassing the *Imports Namespace* |

Absent a `bindings` property, machinery presumes an empty array (such a module may still have global-scope side effects). Dynamic import of a virtual-source `Module` induces the memoized `importHook` of the `Module` for each binding with a `from`; once a `Module` exists for every transitive dependency, dynamic import advances linkage across all namespaces. Absent an `execute` property, an empty execute is assumed (the module may still re-export useful bindings). Dynamic import then executes the working set per the ordinary ordering rules, calling `execute` with the linked *Imports Namespace*, a bound dynamic-import function **only if** `needsImport` is truthy, and an `import.meta` **only if** `needsImportMeta` is truthy.

Source: [proposal-compartments/2-virtual-module-source.md](https://github.com/tc39/proposal-compartments/blob/master/2-virtual-module-source.md) at content sha256 `ffd7fbc7`. Stage 1; retrieved 2026-07-21.
