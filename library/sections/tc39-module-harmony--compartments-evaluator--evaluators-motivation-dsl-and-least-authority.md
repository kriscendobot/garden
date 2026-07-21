---
title: Compartments layer 3 — why Evaluators (DSLs, least authority) and the shared-vs-separate-global question
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/3-evaluator.md
source_content_sha256: 06d24cd6225d7d4f1063978b07f0a262b3788e18b22a532e18ebc08a848c4d62
source_authors: [Mark S. Miller, Caridy Patiño, Kris Kowal, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The motivation and open-question half of Compartments layer 3. Evaluators exist to give code **a separate global scope while sharing the realm's intrinsics** — avoiding the identity-discontinuity hazard of a fresh realm (`array instanceof Array` unreliable across realms). Two motivating use cases: **domain-specific languages** (Mocha/Jest/Jasmine install `describe`/`it` in global scope; evaluators let only the entrypoint module see them, and let DSLs run concurrently instead of tracking the current module through dynamic scope) and **the principle of least authority / supply-chain isolation** (the bulk of a modern web app is its supply chain; developers need to isolate third-party dependencies from powerful globals — and some hosts, like TC53 embedded systems, have no origin to build a same-origin policy on and build their security model on isolated evaluators via the high-level Compartment). The open question is the **shared-vs-separate-`globalThis`** axis: hosts may not accept an arbitrary `globalThis` object, and the argument shape differs between copying properties onto a host-built global (separate) and pointing at an existing one (shared). Interface and rebinding are in `--evaluators-constructor-and-realm-rebinding`.

## Motivation — domain-specific languages

Tools like Mocha, Jest, and Jasmine install the verbs and nouns of their DSL in *global* scope. Isolating those changes today requires a new **realm**, which brings identity-discontinuity hazards: `array instanceof Array` is not as reliable as `Array.isArray`, and the hazard is not limited to intrinsics that anticipated it with work-arounds (`Array.isArray`, thenable `Promise` adoption). Evaluators offer an alternative — evaluate modules or scripts in a **separate global scope with shared intrinsics**:

```js
const dsl = new Evaluators({
  globalThis: { __proto__: globalThis, describe, before, after },
});
const source = await import(entrypoint, { reflect: 'module-source' });
await import(new dsl.Module(source));
```

Only the entrypoint module sees the added globals; the `Module` constructor adopts the host's import hook. Each entrypoint could be granted separate DSL closures — so DSLs could execute **concurrently** and would not need dynamic scope to track which entrypoint called each verb (current DSLs cannot do this).

## Motivation — enforcing the principle of least authority

On the web the same-origin policy has grown effective enough that attackers now attack *from within* the same origin, and the JavaScript ecosystem's richness supplies ample vectors: the bulk of a modern web application is its **supply chain** — the code eventually bundled into same-origin scripts, plus the tools that generate them and prepare the developer environment. Developers of platforms that mediate many parties, or that simply have a deep supply chain, need a mechanism to isolate third-party dependencies and minimize their access to powerful objects (high-resolution timers; network, compute, or storage capabilities). Some hosts — a community of embedded systems represented at **ECMA TC53** — have no origin on which to build a same-origin policy and have elected to build their security model on isolated evaluators, through the high-level **Compartment** interface (layer 4).

## Design question — threading globals (shared vs separate)

Host implementors may not accommodate an arbitrary value for `globalThis`; the proposal asks for the best user experience but may need to adjust if hosts cannot support an arbitrary object or if limits on the given object are insufficient. Evaluators are useful in two modes on the same axis:

- **Separate `globalThis`.** It would be acceptable for the constructor to receive a *bag of properties to copy* onto a host-constructed global object.
- **Shared `globalThis`.** Copying properties is not useful, so the argument pattern would have to differ.

This is precisely the global-object-sharing axis a minimal Compartments spec must take a position on: layer 3 supplies the *distinct* global; a design that shares the surrounding realm's global is choosing the "shared" end and deferring this layer.

Source: [proposal-compartments/3-evaluator.md](https://github.com/tc39/proposal-compartments/blob/master/3-evaluator.md) at content sha256 `06d24cd6`. Stage 1; retrieved 2026-07-21.
