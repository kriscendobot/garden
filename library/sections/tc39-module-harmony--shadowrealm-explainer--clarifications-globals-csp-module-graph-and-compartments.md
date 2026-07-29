---
title: ShadowRealm explainer — clarifications: ordinary non-detachable global, CSP, the per-realm module graph, and the relationship to Compartments
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/explainer.md
source_content_sha256: 4842a1efb89d6b281962be7db9f9b5d4b863bdc6f75137abfc5a44a78031eca9
source_authors: [Dave Herman, Caridy Patiño, Mark S. Miller, Leo Balter, Rick Waldron, Chengzhong Wu]
source_date: 2024-12-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The four clarifications that fix ShadowRealm's boundaries, including the one the module-harmony intersection depends on. A ShadowRealm's global object is an **ordinary object** requiring no exotic internals or new primitives, and it is explicitly **not detachable** from its incubator realm: instances and their globals "have their lifeline to their incubator Realm", work as a group sharing the incubator's settings, and act as encapsulation boundaries "analogous to a closure or a private field". Evaluation is subject to the page's existing Content-Security-Policy, so a `unsafe-eval`-disallowing directive blocks `ShadowRealm#evaluate` while `default-src` can block `ShadowRealm#importValue()`. Each instance must have its own module graph. And on Compartments, the explainer draws the line the library's intersection concept turns on: **ShadowRealm defines no virtualization mechanism for host behavior**, which is exactly what distinguishes it from Compartments. Compartments provides a new Realm constructor whose realms are subject to the Compartment's host virtualization, so the two compose (`compartment.globalThis.ShadowRealm` yields a virtualized realm constructor) rather than compete. Compartments is the more complex API tailoring aspects beyond the global APIs, including internal structure such as the module graph; ShadowRealm "just offers immediate access to what is already specified in ECMAScript". A separate Modules section adds the forward-looking half: ShadowRealm itself provides no module-graph controls, and Compartments "plans to provide the low level hooks to control the module graph per ShadowRealm", named as one of the intersection semantics between the two proposals.

## Terminology

In the Web Platform, `Realm` and `Global Object` are usually associated with Window, Worker, and Worklet semantics and with their detachable nature (they can be pulled out of their parent DOM tree). This proposal is limited to the semantics specified by ECMA-262 with no extra requirements from the web counterparts.

## The ShadowRealm's global object

Each ShadowRealm's global object is an [Ordinary Object](https://tc39.es/ecma262/#sec-ordinary-object); it requires no exotic internals or new primitives.

> Instances of ShadowRealm Objects and their Global Objects have their lifeline to their incubator Realm, they are not *detachable* from it. Instead, they work as a group, sharing the settings of their incubator Realm. In other words, they act as encapsulation boundaries, they are analogous to a closure or a private field.

## Evaluation and CSP

Any code evaluation mechanism in this API is subject to the existing Content-Security-Policy. A page whose CSP directive disallows `unsafe-eval` prevents synchronous evaluation in the ShadowRealm, that is `ShadowRealm#evaluate`. A page CSP can also set directives such as `default-src` to prevent a ShadowRealm from using `ShadowRealm#importValue()`.

## Module graph

Each instance of a ShadowRealm must have its own module graph.

```javascript
const shadowRealm = new ShadowRealm();
const doSomething = await shadowRealm.importValue('./file.js', 'redDoSomething');
doSomething();   // chains to the shadowRealm's redDoSomething
```

## Compartments

> This proposal does not define any virtualization mechanism for host behavior. Therefore, it distinguishes itself from the current existing [Compartments](https://github.com/tc39/proposal-compartments) proposal.
>
> A new Compartment provides a new Realm constructor. A Realm object from a Compartment is subject to the Compartment's host virtualization mechanism.

```javascript
const compartment = new Compartment(options);
const VirtualizedRealm = compartment.globalThis.ShadowRealm;
const shadowRealm = new VirtualizedRealm();
const doSomething = await shadowRealm.importValue('./file.js', 'redDoSomething');
```

> The Compartments proposal offers a more complex API that offers tailoring over aspects beyond the global APIs but with modifications to internal structure such as module graph. The ShadowRealm API just offers immediate access to what is already specified in ECMAScript as it's already structured to distinguish different references from realms.

## Modules: where the two proposals meet

> In principle, the ShadowRealm proposal does not provide the controls for the module graphs. Every new ShadowRealm initializes its own module graph, while any invocation to `ShadowRealm.prototype.importValue()` method, or by using `import()` when evaluating code inside the shadowRealm through wrapped functions, will populate this module graph. This is analogous to same-domain iframes, and VM in nodejs.
>
> However, the Compartments proposal plans to provide the low level hooks to control the module graph per ShadowRealm. This is one of the intersection semantics between the two proposals.

The explainer's virtualized-contexts example makes the isolation concrete: a `blueValue` global in the incubator is not visible inside, and a `redValue` set inside is not leaked out.

## Errors

Errors originating from a ShadowRealm are subject to **stack censoring**. They must be copied when crossing the callable boundary, and in doing so the host must produce a `TypeError`, and may provide `message` and `stack` properties without violating the stack-censoring principle. A separate `errors.md` explainer in the repository carries the detail (not ingested).

## Why not separate processes

Running a realm in a separate process was discarded for two reasons: mechanisms already exist in browsers and Node (cross-origin iframes, workers) and are good enough when asynchronous communication suffices; and asynchronous communication is a deal-breaker for many use cases, "specifically when security is **not** an issue", adding complexity where a same-process realm is sufficient. Google AMP is given as the example: it runs in a cross-origin iframe already and wants more control over what code it executes inside that application.

Source: [proposal-shadowrealm/explainer.md](https://github.com/tc39/proposal-shadowrealm/blob/main/explainer.md) at content sha256 `4842a1ef`. Stage 2.7; retrieved 2026-07-29.
