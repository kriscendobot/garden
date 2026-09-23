---
title: Compartments GRAPH — the motivating use cases, each mapped to the features it needs
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/GRAPH.md
source_content_sha256: 759c00d9848573c2dcc1277c60a78ec64d68dc48676c489218ec8b0a900a02a5
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The motivating-use-cases half of `GRAPH.md` — the demand side of the module-harmony feature map, each use case named with the exact features it requires. It is the raw material for the concept page's "which proposal must a minimal Compartments spec adopt vs defer" argument: it shows *why* each layer exists. Use cases: non-JavaScript not-host-defined modules and asset modules (minimal virtual source); WASM not-host-defined modules (minimal virtual source); deferred module execution (static `import module` + `Module` instance); module multiple-instantiation (`Module` constructor + module source concept); hot module replacement (`Module` constructor + module source concept + bindings reflection + `import.meta` injection); module-block bundle generator/runtime (module blocks + bindings reflection + `ModuleSource` constructor); import WASM with CSP (static `import module` + `Module` instances + module source concept); inter-agent module-block transfer (`module` block with source); module instrumentation (maximal virtual source + bindings reflection); DSLs and supply-chain isolation (Evaluators, with Compartments as the higher-level wrapper). The feature-supply catalog is in `--feature-to-layer-map-and-module-proposals`.

## Use cases and the features they require

| Use case | Requires |
|---|---|
| **Non-JavaScript not-host-defined modules** | a *minimal virtual module source protocol* — lets user code implement module kinds a host did not anticipate, exploring useful module kinds ahead of host implementations |
| **Asset modules** (binary → ArrayBuffer, text, image → blob/URL/path, JSON, CSS-as-side-effect) | minimal virtual source suffices; incorporating assets in the graph makes a program portable dev↔prod and lets a bundler observe the dependency and order it |
| **WebAssembly not-host-defined modules** | minimal virtual source — user code emulates the web's standard WASM-in-graph behavior on hosts that lack it |
| **Deferred module execution** | static `import module` (or dynamic `import.module`) + a `Module` instance: `import module example from 'example'; await import(example);` — solves only the leading portion of the deferred-module-evaluation proposal, not lazy initialization |
| **Module multiple-instantiation** | the `Module` constructor + the module source concept; each instance's `importHook` can link it to different or shared dependency instances. A source may come from a `module` block, `import module`, `import.module`, or `new ModuleSource(text)` — all sources need a `[[ModuleSource]]` slot; a host may withhold `source` |
| **Hot module replacement** | `Module` constructor + module source concept + `ModuleSource` bindings reflection (to maintain the graph and co-graph and update incrementally) + `import.meta` injection (to hand module state from one version to the next); the `ModuleSource` constructor is the obvious dev-time source |
| **Module-block bundle generator and runtime** | `module` blocks + `ModuleSource` bindings reflection + `ModuleSource` constructor — statically analyze a graph on one host, then emit a bundle of `module` blocks that preserve each module's origin host-data (Nicolò Ribaudo sketched one) |
| **Import WASM with Content-Security-Policy** | static `import module` + `Module` instances + module source concept; the host gives `WebAssembly.Module` a `[[ModuleSource]]` slot so `import module x from 'x.wasm'` yields a deferrable, manually-linkable `Module` under `no-unsafe-eval` CSP with a statically-observable dependency (this is the Import Reflection proposal's primary motivation) |
| **Inter-agent module-block transfer** | a `module` block with `source` → a `Module` + `ModuleSource` instance that, with a transfer mechanism for source and host metadata (referrer, `import.meta.url`, signed origin), can execute in another agent such as a web worker (the Module Blocks proposal's primary motivation) |
| **Module instrumentation** | a *maximal* virtual `ModuleSource` protocol + bindings reflection — to build adapters/mocks between module instances; the maximal protocol is required to emulate JavaScript fully (cyclic dependencies, temporal dead zones, hoisted-declaration initialization, lazy bindings), needing two phases |
| **Domain-specific-language scripts and modules** | Evaluators — run a module in the same realm/intrinsics but a user-defined global (`describe`/`it`), avoiding both cross-realm identity discontinuity and the dynamic-scope tracking current DSLs need; obtain the entrypoint source via dynamic `import.module`, then run it through a new evaluator batch's `Module` |
| **Supply-chain isolation** | Evaluators + pervasive freezing of shared intrinsics → run each third-party dependency in an inescapable environment with limited powers; static analysis generates human-meaningful assessments/policies of a package's apparent needs. **Compartments** provide the higher-level abstraction for the same functionality as Evaluators + dynamic `import.module` |

Source: [proposal-compartments/GRAPH.md](https://github.com/tc39/proposal-compartments/blob/master/GRAPH.md) at content sha256 `759c00d9`. Stage 1; retrieved 2026-07-21.
