---
title: ShadowRealm explainer — the API, its motivations, its non-goals, and how a ShadowRealm operates
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/explainer.md
source_content_sha256: 4842a1efb89d6b281962be7db9f9b5d4b863bdc6f75137abfc5a44a78031eca9
source_authors: [Dave Herman, Caridy Patiño, Mark S. Miller, Leo Balter, Rick Waldron, Chengzhong Wu]
source_date: 2024-12-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, capability-security]
status: current
---

Abstract: What the ShadowRealm API is, what it is deliberately not, and the mechanism that makes it different from every other isolation primitive on the web. The stated primary goal is "to provide a proper mechanism to control the execution of a program, providing a new global object, a new set of intrinsics, no access to objects cross-realms, a separate module graph and synchronous communication between both realms". The mechanism that buys all of that at once is the **callable boundary**: `importValue` and `evaluate` return only primitives or callables, and a callable crossing the boundary becomes a *wrapped function exotic object* with a custom `[[Call]]` whose connection to the far-side function is internal and untraceable from user land. Because no object values cross, the **identity discontinuity** that plagues iframes (`list instanceof Array` failing for an array from another realm) is structurally impossible here, and no serialization is needed, because the ShadowRealm shares the incubator realm's heap and thread. The non-goals are stated as plainly: no host hooks or control over I/O, no availability protection (same thread by design, which is what makes synchronous communication possible), and no full confidentiality. A ShadowRealm is not a new evaluation mechanism either: its code evaluation is subject to the incubator realm's Content-Security-Policy exactly as any other evaluation is.

## The API

```ts
declare class ShadowRealm {
    constructor();
    importValue(specifier: string, bindingName: string): Promise<PrimitiveValueOrCallable>;
    evaluate(sourceText: string): PrimitiveValueOrCallable;
}
```

The specification defines the constructor; `ShadowRealm#importValue()`, equivalent to the `import()` expression but capturing a primitive or callable value; `ShadowRealm#evaluate`, which promotes an indirect eval in the shadow realm but allows the return only of primitive or callable values; and:

> A new wrapped function exotic object with a custom `[[Call]]` internal that has a shared identity of a connected function from another realm associated to it. This identity is not exposed and there is no way to trace back to connected functions cross-realms in user-land.

The explainer's worked example shows both directions of the boundary: an imported `add` comes back as a wrapped function that chains to the imported binding, `red.evaluate('globalThis.someValue = 2')` affects only the ShadowRealm's global, and a callback passed *into* a wrapped function is itself wrapped on the way in.

```javascript
const red = new ShadowRealm();
const redAdd = await red.importValue('./inside-code.js', 'add');
let result = redAdd(2, 3);              // 5
globalThis.someValue = 1;
red.evaluate('globalThis.someValue = 2');
console.assert(globalThis.someValue === 1);
```

## Motivations

Applications routinely contain programs from multiple sources: different teams, vendors, package managers, or programs with different requirements of the environment. Those programs contend for shared global resources, above all the shared global object, and their side effects are often hard to observe, causing conflicts between programs and potentially affecting the integrity of the application itself.

Solving this with existing DOM APIs requires an asynchronous communication protocol, which "is often a deal-breaker for many use cases" and adds complexity where a same-process realm would suffice; values also cannot be shared immediately, because other communication mechanisms require serialization. Two further motivations are named: virtualization and portability (standardizing some of what Node's `vm` module does, for all environments), and the current inability to completely virtualize the environment a program executes in.

## Non-goals

> This proposal does not aim to provide host hooks, or any other mechanism to control or prevent IO operations from within the ShadowRealm instance.
>
> The ShadowRealm proposal does not aim to provide availability protection as it is designed to share the same thread to allow synchronous communication between Realms.
>
> It does not provide full protection for confidentiality, as such, a ShadowRealm instance initially provides access to APIs that can be used to infer information and sense the timing from the environment in various ways.

## How a ShadowRealm operates

A ShadowRealm executes code with the **same JavaScript heap** as the surrounding context that created it, and runs synchronously in the same thread. The surrounding context is called the **incubator realm** throughout the proposal.

Same-origin iframes also create a synchronously accessible new global object. A ShadowRealm differs by omitting Web APIs such as the DOM and the async config for code injected through dynamic imports, and, decisively:

> Problems related to identity discontinuity exist in iframes but are not a possibility in a ShadowRealm as object values are not transferred cross-realms in user land. The only connection exists internally through wrapped functions.

The explainer credits experience with same-origin iframes at Salesforce as the motivation for pushing the proposal, and lists the advantages: frameworks can craft the ShadowRealm's global API to just what a program needs; tailoring a minimal surface *up* is cheaper and better than tailoring a full surface *down* (which means handling `[LegacyUnforgeable]` attributes such as `window.top`); a ShadowRealm should be lighter in memory and CPU than an iframe, especially when a framework uses several; it is not reachable by traversing the incubator's DOM; and a new ShadowRealm has no immediate access to any object from the incubator realm, or the reverse, and no `window.top`.

The API is positioned as **complementary** to stronger isolation such as Workers and cross-origin iframes, useful where synchronous execution is essential (emulating the DOM for third-party integration) and where a shared heap avoids prohibitive serialization overhead. It introduces no new evaluation mechanism: evaluation is subject to the same CSP restrictions as the incubator realm, or any other restriction in Node. Each ShadowRealm instance contains its own separate module graph running in that ShadowRealm's context.

Source: [proposal-shadowrealm/explainer.md](https://github.com/tc39/proposal-shadowrealm/blob/main/explainer.md) at content sha256 `4842a1ef`. Stage 2.7; retrieved 2026-07-29.
