---
title: Compartments layer 3 — the Evaluators constructor and rebinding execution contexts from realm to evaluators
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

Abstract: Compartments **layer 3** (`3-evaluator.md`) adds an **`Evaluators` constructor** that produces a fresh `eval`, `Function`, and `Module` — a triple whose execution contexts refer back to *this* evaluator set, carrying a given **global object** and a virtualized `importHook`/`importMeta`. This is the layer that supplies a *distinct global object without a distinct realm*, and the layer the fresh minimal Compartments design **defers** when it lets a Compartment's modules share the surrounding realm's global. This section states the constructor interface and the spec-level rebinding: execution contexts and the `eval`/`Function`/`Module` instances, previously bound to a *realm*, become bound to their *evaluators*, which is in turn bound to the realm — inserting a `[[Context]] → [[Evaluators]] → [[Realm]]` indirection so multiple evaluator sets can coexist in one realm. The motivation (DSLs, least authority) and the shared-vs-separate-global design questions are in `--evaluators-motivation-dsl-and-least-authority`.

## Interface

```ts
interface Evaluators {
  constructor({
    globalThis?: Object,
    importHook?: ImportHook,
    importMeta?: Object,
  });
  eval: typeof eval,
  Function: typeof Function,
  Module: typeof Module,
};
```

## Design — rebinding from realm to evaluators

Where **Execution Contexts** and instances of `eval`, `Function`, and `Module` were previously bound to a *realm*, they become bound to their **evaluators** instead, which in turn is bound to the realm:

- All references to `%eval%` must now refer to `[[Realm]].[[Evaluators]].[[Eval]]`.
- All other references to `[[Context]].[[Realm]]` must be replaced with `[[Context]].[[Evaluators]].[[Realm]]`, particularly to address the realm's intrinsics.

This adds one level of indirection (`[[Context]]` → `[[Evaluators]]` → `[[Realm]]`) so that **there can be multiple sets of evaluators in a single realm**, each with its own global and module behavior.

### Direct eval is unchanged, but the creator must thread `eval`

The rules for *direct* eval do not change: the name `eval` must be bound to `[[Context]].[[Evaluators]].[[Eval]]` for the `eval` special form to be interpreted as direct eval. The creator of new evaluators must arrange for `evaluators.eval` to be threaded into lexical scope for this to keep working:

```js
const localThis = { __proto__: globalThis };
const evaluators = new Evaluators({ globalThis: localThis });
localThis.eval = evaluators.eval;
evaluators.eval(`
  eval('var local = 42');
  typeof local === 'number'; // true
`);
```

### globalThis, importHook, importMeta

The constructor accepts a `globalThis`; the **Global Environment Record** in execution contexts reaches out to this object for global-scope properties. If absent, the new evaluators receive the `Evaluators` constructor's own `[[Context]].[[Evaluators]]`. The `importHook` has the same signature as layer 0's, and the new `Module` constructor **adopts its evaluator's `[[ImportHook]]` and `[[ImportMeta]]`** when called without the corresponding options; module execution contexts in turn use the `[[ImportHook]]`/`[[ImportMeta]]` from their `Module` constructor. Dynamic import in *script* execution contexts uses `[[Context]].[[Evaluators]].[[ImportHook]]`, receiving the specifier and `[[Context]].[[Evaluators]].[[ImportMeta]]`.

Source: [proposal-compartments/3-evaluator.md](https://github.com/tc39/proposal-compartments/blob/master/3-evaluator.md) at content sha256 `06d24cd6`. Stage 1; retrieved 2026-07-21.
