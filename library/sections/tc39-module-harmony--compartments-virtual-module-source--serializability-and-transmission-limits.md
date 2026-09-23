---
title: Compartments layer 2 — the serializability invariant and virtual-source transmission limits
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

Abstract: The open design questions and the hard limitation of Compartments layer 2 — the axis a minimal Compartments spec must weigh before adopting the virtualization protocol. **Design questions:** Caridy Patiño prefers an even lower-level API that constructs a `Module` plus its import/export namespaces *from bindings alone* (no virtual source at all), to preserve the invariant that module sources are serializable; whether virtual sources should support emulated JavaScript (which needs initialization split from execution as separate phases); and whether the `execute` method's two inputs (globals and the internal bindings view) should be one reified environment record or two objects. **The limitation:** a compiler-produced `ModuleSource` is serializable and shareable across an agent cluster (in the naive case just source text plus type; in an elaborate case, bytecode), and `WebAssembly.Module` can be too, but **virtual module sources are not transmissible by a general-purpose algorithm** like structured clone — any host mechanism for transmitting module graphs necessarily fails on a virtual source, so cross-agent transport of virtual sources must be implemented in user code.

## Design questions

- **Module-source serializability invariant.** Caridy Patiño prefers a lower-level API where, instead of virtualizing evaluation, the language provides a way to construct a `Module` instance *along with its imports and exports namespaces from their bindings*. In that model there would be **no virtual module source, just modules** — protecting the invariant that module sources are serializable.
- **Emulated JavaScript.** [Should virtual module sources support emulated JavaScript?](https://github.com/tc39/proposal-compartments/issues/70) In some cases that requires separating *initialization* from *execution* as distinct phases; should the protocol offer separate paths for modules that need no initialization phase?
- **Shape of the internal namespace object.** `execute` needs both the global object and an internal view of bindings. These could be a single reified *module environment record*, or the two separate objects as currently written. Future module amendments may add lexical names to the environment record that are not properties of the global object.

## Limitation — virtual sources are not generally transmissible

Sources compiled by the `ModuleSource` constructor capture enough that engines can transfer them in many ways: the internal representation can be an immutable record trivially shared throughout an agent cluster, and communicating agent clusters can transfer module sources as data.

- In the **naive** case a module source is just a record of the original source text and its type (not limited to JavaScript — hosts can define additional source types; for example `WebAssembly.Module` extended with a `[[ModuleSource]]` slot). Two agent clusters need only transfer source and type.
- In a more **elaborate** case the source retains compiled bytecode rather than text, and two compatible clusters might send and receive bytecode.

**Virtual** module sources, by contrast, are transmissible between agent clusters *only* if both sides agree on a protocol for reconstructing the virtual source from a serial representation. It would **not** be possible to transmit arbitrary virtual sources with a general-purpose algorithm like structured clone; the protocol must live in user code. Any general-purpose host mechanism for transmitting module graphs necessarily fails on encountering a virtual module source. Structured clone might be extended to transmit `ModuleSource` (or `WebAssembly.Module` with a host extension) between any JavaScript hosts, but that cannot generalize to virtual sources.

Source: [proposal-compartments/2-virtual-module-source.md](https://github.com/tc39/proposal-compartments/blob/master/2-virtual-module-source.md) at content sha256 `ffd7fbc7`. Stage 1; retrieved 2026-07-21.
