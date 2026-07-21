---
id: module-harmony-intersection-surface
aliases: ["module harmony", "module harmony intersection", "intersection semantics module harmony", "ModuleSource as key", "ModuleSource opaque key", "source phase imports", "import source", "import.source", "AbstractModuleSource", "import defer", "deferred module evaluation", "module expressions", "module blocks", "module declarations", "module fragments", "import module", "import.module", "minimal Compartments intersection"]
topics: [module-harmony, compartments]
---

# module-harmony-intersection-surface

The **intersection** a minimal Compartments spec must satisfy to be coherent under **module harmony** — the family of TC39 module proposals (source phase imports, import defer, module expressions, module declarations, and the layered Compartments proposal itself) that jointly reshape how modules are compiled, phased, reified, and virtualized. For each proposal this page states what a minimal Compartments spec must **adopt**, what it can **defer to** (let the proposal own), and what it must **stay compatible with** — plus the contradictions and open questions that are not yet resolved. It grounds the design tenet *"intersection semantics across all related proposals, coherent under module harmony"* (`journal/projects/proposal-compartments`). Ground truth is the specifications as written (Stage noted per proposal); where XS/SES already implement a phase it is evidence, not spec.

The unifying idea of module harmony is **phases of one module load**: resolving, fetching, attaching, linking, and executing are stages of a single request keyed in the module map, and `import source` / `import defer` / plain `import` are all *guaranteed to load the same module, executed at most once* regardless of which phase they pause at. A minimal Compartments spec lives inside that phase model rather than beside it.

## The keystone: `ModuleSource` as an opaque, powerless key

The fresh design has **abandoned module descriptors** and instead uses a **`ModuleSource` as an opaque key** to index a module *instance* in a Compartment, over a Compartment whose modules share the **surrounding realm's global object** (or a compartment-specific one). The proposals converge on exactly this shape:

- **`ModuleSource` is powerless and immutable** (source-phase + Compartments layer 0): it gives its holder no authority, captures only what static analysis infers, and is serializable/shareable across realms and agent clusters. That is what makes it safe to use as a *key*.
- **One `ModuleSource` → many `Module` instances → many namespaces** (Compartments layer 0): `new Module(source)` twice yields two instances and two namespaces; importing one instance twice yields one namespace. So "index a module instance by its source" is a many-instances-per-source map, not a source→namespace identity.
- **`%AbstractModuleSource%.prototype`** (source-phase) is the shared brand every compiled modular resource (`ModuleSource`, `WebAssembly.Module`, host/virtual sources) carries, with an `@@toStringTag` internal-slot check — the type a minimal spec must brand-check its opaque key against.

## Per-proposal intersection

| Proposal | Stage | A minimal Compartments spec must **adopt** | Can **defer to** | Must **stay compatible with** |
|---|---|---|---|---|
| **Source phase imports** (`import source`, `import.source`) | 3 | `%AbstractModuleSource%.prototype` + `ModuleSource` as the compiled-source value; the "source phase" as the phase that yields the opaque key; `ReferenceError` at link time when no source representation exists | The `import source`/`import.source` *syntax* and the host's source-reification (a minimal spec can consume `ModuleSource` values without owning the syntax) | Cache-key-on-base-module-record (unique source object per module, load idempotency preserved); orthogonality of import attributes vs phases; the promise that the source object is "compatible with the linking model of module expressions and compartments" |
| **Import defer** (`import defer * as ns`) | 3 | Nothing structurally required, but the **phases model** it shares with source-phase; the guarantee that all phases load the same module executed at most once | The deferred-namespace-exotic-object machinery and its synchronous-`[[Get]]`-triggers-evaluation semantics (a host/loader concern) | The rule that a deferred namespace differs from a plain namespace (re-throws evaluation errors); TLA subgraphs eagerly evaluated; **do not** re-express deferral as an import *attribute* — it changes namespace behavior |
| **Module expressions** (`module { }`) | 3 (reviewers listed) | The intersection identity `(module {}) instanceof Module` and `(module {}).source instanceof ModuleSource` — the `Module`/`ModuleSource` classes a minimal spec defines are the *same* classes module expressions produce | The `module { }` syntax, realm-capture, no-closure, structured-clone, and HTML integration | The "minimal `Module` class that Compartments expands" contract (module expressions deliberately ship a limited `Module`, expecting Compartments to grow it); caching "like object literals"; single-realm evaluation |
| **Module declarations** (`module x { }`) | 2 | Nothing beyond the shared `Module` identity and no-shared-scope rule | The named-inline-module syntax, static importability, singleton semantics, and the whole bundling story (declarations nested in resource bundles) | The no-shared-lexical-scope-between-declaration-and-container invariant; `import.meta.url` of the outer module for relative resolution |
| **Compartments layer 0** (first-class `Module`/`ModuleSource`) | 1 | This *is* the layer a minimal spec is a subset of: `ModuleSource`/`Module` constructors, `ModuleHandler` with eagerly-captured `importHook`/`importMetaHook`, dynamic-import-as-kicker, the 1-1-1-1 record relationship, the referrer-on-the-handler design | The full five-layer stack (static-analysis reflection, virtual module sources, `Evaluators`, high-level `Compartment`) — a minimal spec can ship layer 0 and leave 1–4 to follow | The non-virtualizable **origin** in module-source host data (a virtual host must not escape same-origin/CSP); referrer independent from `import.meta.url`; `importHook` async |

## Global-object sharing

A Compartment shares the realm's **intrinsics** but has **its own global object** and its own evaluators (`eval`, `Function`, `Module`) — this is the Stage-1 Compartments synopsis and the basis for granting a compartment only the powers it needs. The fresh minimal design's choice to let a Compartment's modules share the *surrounding realm's* global object (rather than mint a fresh one) is a *narrowing* of that surface: it stays compatible with the layer-0 model (evaluators are realm-bound; a `Module` constructor evaluates in its realm) while deferring the `Evaluators`-constructor layer that would supply a *distinct* global. Coherent, but note that "share the realm global" and "own global per compartment" are two positions on the same axis; a minimal spec should be explicit about which it takes.

## Contradictions and open questions (explicit)

1. **`Module` vs `ModuleInstance` naming (unresolved).** Layer 0 tentatively names the *instance* `Module` (anticipating `(module {}) instanceof Module`), but `WebAssembly.Module` resembles a module *source*, which would push toward `ModuleSource` = `Module` and instance = `ModuleInstance`. The fresh design's "`ModuleSource` as key" framing must pick a lane; this naming is upstream-unsettled.
2. **`import module` / `import.module` phase syntax.** Layer 0's deferred-execution examples use `import module example from 'example.js'` and `await import.module(…)` to obtain an *unexecuted* `Module`. This is a *third* phase keyword beyond `source` and `defer`; whether a minimal Compartments spec adopts it, or reconstructs the same capability from `import.source` + `new Module(source, handler)`, is an open intersection decision. (The two are shown as interchangeable in the source text.)
3. **Deferred re-exports (open extension of import defer).** Not in the current proposal; a minimal spec should not depend on them.
4. **Synchronous-eval API on the module instance.** Import defer explicitly *declines* to solve deferral via a synchronous-eval method on the compartments `ModuleInstance`, preferring syntax. A minimal spec that exposes such a method would be re-opening a deliberately-closed door.
5. **Descriptors abandoned vs upstream still descriptor-shaped.** The upstream Stage-1 Compartments README and older Endo `ses` still carry module-descriptor / module-map-hook framing (see [[compartment-module-descriptor]] evidence in the endo corpus); the fresh design has dropped descriptors for the opaque-`ModuleSource`-key. This is a divergence from upstream-as-written that the intersection must reconcile — adopt layer 0's `Module`/`ModuleSource`, *not* the descriptor surface.

## Evidence vs spec (XS / SES)

Endo's `@endo/module-source` already ships a `ModuleSource` constructor, and `ses` Compartments already implement `moduleMapHook` / `importHook` / virtual module sources — these are *evidence* that the layer-0 shape is implementable and roughly what the ecosystem wants, **not** the normative intersection. Where the fresh spec and the SES implementation disagree (descriptors, per-compartment global), the spec-as-written governs and the SES behavior is a data point. See [[compartments]] topic for the SES-side sections.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [tc39-module-harmony--source-phase-imports--overview-motivation-and-source-phase](../sections/tc39-module-harmony--source-phase-imports--overview-motivation-and-source-phase.md) | The source loading phase and its motivation (userland JS loaders, Wasm wrapping). |
| [tc39-module-harmony--source-phase-imports--abstract-module-source-and-module-source-objects](../sections/tc39-module-harmony--source-phase-imports--abstract-module-source-and-module-source-objects.md) | `%AbstractModuleSource%.prototype`, `ModuleSource`, Wasm re-parenting, brand check. |
| [tc39-module-harmony--source-phase-imports--cache-key-and-relationship-to-other-proposals](../sections/tc39-module-harmony--source-phase-imports--cache-key-and-relationship-to-other-proposals.md) | Cache-key-on-base-record; attributes vs phases; compatibility with expressions/compartments. |
| [tc39-module-harmony--import-defer--import-defer-semantics-and-namespace-exotic](../sections/tc39-module-harmony--import-defer--import-defer-semantics-and-namespace-exotic.md) | Deferred namespace exotic object; sync `[[Get]]` eval; TLA eager; throw-on-access. |
| [tc39-module-harmony--import-defer--phases-model-modifiers-vs-attributes](../sections/tc39-module-harmony--import-defer--phases-model-modifiers-vs-attributes.md) | The shared phases model; import modifiers vs attributes; deferred re-exports open. |
| [tc39-module-harmony--module-expressions--relationship-to-module-class-and-bundling](../sections/tc39-module-harmony--module-expressions--relationship-to-module-class-and-bundling.md) | `module {}` → minimal `Module` that Compartments expands; bundling needs declarations. |
| [tc39-module-harmony--module-declarations--named-inline-modules-for-bundling](../sections/tc39-module-harmony--module-declarations--named-inline-modules-for-bundling.md) | Named static-importable inline modules; singletons; no shared scope. |
| [tc39-module-harmony--compartments-overview--five-layer-compartment-structure](../sections/tc39-module-harmony--compartments-overview--five-layer-compartment-structure.md) | The five layers; separate global object; user-code-constructible compartments. |
| [tc39-module-harmony--compartments-module-and-source--modulesource-and-module-instance-model](../sections/tc39-module-harmony--compartments-module-and-source--modulesource-and-module-instance-model.md) | Powerless immutable `ModuleSource`; `Module` lifecycle; 1-1-1-1; source reuse. |
| [tc39-module-harmony--compartments-module-and-source--virtual-import-hooks-and-referrer](../sections/tc39-module-harmony--compartments-module-and-source--virtual-import-hooks-and-referrer.md) | `ModuleHandler`, eagerly-captured hooks; referrer vs `import.meta.url` vs origin. |
| [tc39-module-harmony--compartments-module-and-source--intersection-semantics-and-262-factoring](../sections/tc39-module-harmony--compartments-module-and-source--intersection-semantics-and-262-factoring.md) | Intersection examples (blocks, deferred exec, `import.meta.resolve`); 262 refactoring; naming. |

## See also

- [[compartments]] — the SES-side Compartment isolation model (evidence, not spec).
- The `module-harmony` topic page — the full section inventory for these proposals.
