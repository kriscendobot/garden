---
title: "Cordis revertible effects: temporal composability as code"
source: packages/core/tests/dispose.spec.ts
source_repo: cordiverse/cordis
source_commit: 9a85c8b4fa860601da3466da198cf59a73e59b29
source_date: 2026-08-13
source_authors: [cordiverse]
ingested: 2026-08-14
ingested_by: scholar
topics: [change-propagation, effect-and-coeffect-systems]
status: current
notes: "Worked examples from the core test suite; the effect-registration API lives in packages/core/src/registry.ts (commit b4b5501b) and the fiber/scope in packages/core/src/fiber.ts (commit 752dbee9)."
---

Abstract: The paper's *revertible effects* — "every context transformation carries an inverse that the runtime tracks" — are the `ctx.effect(setup)` primitive. `setup` runs the forward transformation and returns (or yields) its **inverse** (a disposer); the runtime records it on the owning **fiber**; reverting is `fiber.dispose()` (or calling the returned disposer). Reversion is **idempotent** (disposing twice runs the inverse once), effects nest into a tree and revert in **LIFO order**, and event listeners (`ctx.on(...)`) are themselves revertible effects. After disposal the context is **inactive** and further `plugin`/`effect`/`on` calls throw. This is temporal composability made mechanical: removing a component completely undoes its side effects.

## `ctx.effect(setup)` — a transformation and its tracked inverse

The `dispose by plugin` spec: a plugin registers one effect whose inverse is `dispose`; the effect shows up on the fiber's effect tree; disposing the fiber runs the inverse exactly once, idempotently:

```ts
const root = new Context()
const dispose = mock.fn()
const fiber = await root.plugin((ctx) => {
  ctx.effect(() => dispose, 'test')
})
expect(fiber.getEffects()).to.deep.equal([
  { label: 'test', children: [] },
])
expect(dispose.mock.calls).to.have.length(0)
await fiber.dispose()
expect(dispose.mock.calls).to.have.length(1)
await fiber.dispose()          // idempotent: still 1
expect(dispose.mock.calls).to.have.length(1)
```

`ctx.effect(() => dispose1)` also returns a disposer directly, so an effect can be reverted manually without disposing the whole fiber — and that manual disposer is likewise idempotent:

```ts
const dispose2 = root.effect(() => dispose1)
dispose2()                      // runs dispose1 once
dispose2()                      // no-op
```

## Nested effects revert in LIFO order (the `yield dispose` spec)

An effect's `setup` may be a generator that **yields** several inverses (and nested `ctx.effect(...)` / `ctx.on(...)` sub-effects). The runtime builds an effect tree and, on disposal, runs the inverses in reverse registration order:

```ts
const seq: number[] = []
const dispose = root.effect(function* () {
  yield dispose1               // pushes 1
  yield root.on('custom-event', () => {})
  yield dispose2               // pushes 2
  yield root.effect(function* () {
    yield root.on('custom-event', () => {})
    yield dispose3             // pushes 3
  })
})
dispose()
expect(seq).to.deep.equal([3, 2, 1])   // LIFO reversal
dispose()
expect(seq).to.deep.equal([3, 2, 1])   // idempotent
```

The reverse order matters for soundness: later effects may depend on state set up by earlier ones, so their inverses must run first — the same discipline a well-behaved teardown stack (or the garden's own worktree/effect cleanup) must observe.

## Listeners are revertible effects

`ctx.on('custom-event', handler)` returns a disposer and appears in the fiber's effect tree as `ctx.on("custom-event")`. Registering a listener is thus a context transformation with a tracked inverse, exactly like any other effect — there is no separate "unsubscribe" bookkeeping the caller must remember; disposing the fiber removes the listener.

## "inactive context" — the calculus of active scope

Once a fiber is disposed its context becomes **inactive**: further transformations throw. From the `plugin` spec:

```ts
const fiber = root.plugin((ctx) => {
  return () => {
    expect(() => ctx.plugin(callback)).to.throw('inactive context')
    expect(() => ctx.effect(() => () => {})).to.throw('inactive context')
    expect(() => ctx.on('custom-event', () => {})).to.throw('inactive context')
  }
})
await fiber.dispose()
```

This is the runtime enforcement of the paper's metatheory: a component's context is a live scope only while the component is present; after removal the scope is closed and cannot accrue new (un-revertible) effects.

Source: [packages/core/tests/dispose.spec.ts](https://github.com/cordiverse/cordis/blob/9a85c8b4fa860601da3466da198cf59a73e59b29/packages/core/tests/dispose.spec.ts) at commit `9a85c8b4`; effect API in [packages/core/src/registry.ts](https://github.com/cordiverse/cordis/blob/b4b5501b18b614b520cd60ac6e2d2a52d9f160a3/packages/core/src/registry.ts) (`b4b5501b`) and [fiber.ts](https://github.com/cordiverse/cordis/blob/752dbee9515f43f6c84c7adbb1caeaa6ecab4c0a/packages/core/src/fiber.ts) (`752dbee9`).
