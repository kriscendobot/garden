---
title: "Cordis reactive coeffects and services: spatial composability as code"
source: packages/core/tests/service.spec.ts
source_repo: cordiverse/cordis
source_commit: 44a38e1db71ef054a871754467c03bd883afbc08
source_date: 2026-08-13
source_authors: [cordiverse]
ingested: 2026-08-14
ingested_by: scholar
topics: [change-propagation, effect-and-coeffect-systems]
status: current
notes: "Worked examples from the core test suite; the service/inject API lives in packages/core/src/service.ts (commit dd346230)."
---

Abstract: The paper's *reactive coeffects* — "each change of the context notifies a component against its coeffect specification" — are Cordis's `Service` + `ctx.inject([...])` mechanism. A component declares the services it consumes (`static inject = ['counter']`, or `ctx.inject(['foo'], callback)`); the callback is a scope that **activates only when every declared dependency is available** and is **reactively disposed when a dependency goes away**. A service registers itself with `ctx.provide('name')` + `ctx.set('name', instance)` (or by extending `Service`), and may gate its own readiness with `Service.init` so dependents block until initialization completes. This is spatial composability: inter-component dependencies are declared, not wired by hand, and the runtime keeps them consistent as the context changes.

## `ctx.inject([...], callback)` — a coeffect-gated scope

`inject` declares a dependency and supplies a callback that runs as its own fiber only while the dependency is present. From the `pending inject` spec, the callback stays dormant until the service both exists and finishes `Service.init`:

```ts
class Foo extends Service {
  constructor(ctx: Context) { super(ctx, 'foo') }
  async [Service.init]() {
    await new Promise<void>((resolve) => {
      this.ctx.on('custom-event', resolve)   // init is not done until this fires
    })
  }
}

const root = new Context()
const callback = mock.fn()
root.inject(['foo'], callback)
expect(callback.mock.calls).to.have.length(0)   // no `foo` yet

root.plugin(Foo)
await sleep()
expect(callback.mock.calls).to.have.length(0)   // blocked by Service.init

root.emit('custom-event')                         // init resolves
await sleep()
expect(callback.mock.calls).to.have.length(1)   // now the coeffect is satisfied
```

The component never polls for its dependency; the runtime **notifies** it when the coeffect specification (`['foo']`) is met — the paper's reactive coeffect, verbatim.

## Providing a service: `provide` + `set`, or extend `Service`

A service is registered on the context and then read as a property (`ctx.foo`, `ctx.counter`). The `traceable effect (with inject)` spec shows both the manual (`provide`/`set`) and the `Service`-subclass forms interoperating, and shows the injected scope tearing down cleanly:

```ts
class Foo extends Service {
  static inject = ['counter']                     // declares its own coeffect
  constructor(ctx: Context) { super(ctx, 'foo') }
  get value() { return this.ctx.counter.value }
  increase() { return this.ctx.counter.increase() }
}

const root = new Context()
root.provide('counter')
root.set('counter', new Counter(root))            // register a dependency service

await root.plugin(Foo)                             // Foo activates: 'counter' is present
root.foo.increase()
expect(root.foo.value).to.equal(1)

const fiber = await root.inject(['foo'], (ctx) => {
  root.foo.increase()
  expect(ctx.foo.value).to.equal(2)
})
await fiber.dispose()                              // the injected scope reverts
root.foo.increase()
expect(root.foo.value).to.equal(3)
```

`static inject = ['counter']` on `Foo` is a component-level coeffect declaration: `Foo` will not activate until `counter` is provided, and `ctx.foo` is only reachable inside an `inject(['foo'], ...)` scope (accessing a non-injected service warns — the `warning` mock in the spec asserts zero warnings on the traced paths). Dependencies compose transitively: `inject(['foo'])` transitively requires `counter`, because `Foo` requires it.

## Why this is "reactive" and not just dependency injection

Classical DI resolves a dependency graph once at construction. Cordis's coeffects are **reactive**: because service registration is itself a revertible effect (see [cordis--revertible-effects](cordis--revertible-effects.md)), removing a provider (disposing the fiber that called `set`) fires the inverse, which the runtime propagates to every `inject` scope that depended on it — those scopes dispose in turn, LIFO. The dependency graph is therefore maintained continuously as components come and go, which is exactly what a plugin system or a self-evolving agent harness (the paper's motivating examples) needs and what static DI does not provide. This is the spatial dual of the temporal reversion in the sibling section, and the reason both are unified on one `Context`.

Source: [packages/core/tests/service.spec.ts](https://github.com/cordiverse/cordis/blob/44a38e1db71ef054a871754467c03bd883afbc08/packages/core/tests/service.spec.ts) at commit `44a38e1d`; service API in [packages/core/src/service.ts](https://github.com/cordiverse/cordis/blob/dd346230e10c032ebb011bfe92dde75b370e8d53/packages/core/src/service.ts) (`dd346230`).
