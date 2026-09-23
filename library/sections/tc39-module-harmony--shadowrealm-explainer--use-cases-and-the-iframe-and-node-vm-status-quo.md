---
title: ShadowRealm explainer — use cases, and why iframes and Node's `vm` are the unsatisfactory status quo
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/explainer.md
source_content_sha256: 4842a1efb89d6b281962be7db9f9b5d4b863bdc6f75137abfc5a44a78031eca9
source_authors: [Dave Herman, Caridy Patiño, Mark S. Miller, Leo Balter, Rick Waldron, Chengzhong Wu]
source_date: 2024-12-01
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, testing]
status: current
---

Abstract: The demand side of the ShadowRealm proposal, and the two workarounds it exists to replace. Five use cases are named: third-party scripts (many mutually conflicting libraries in one application, loaded non-blockingly through `importValue`, with no need for immediate access to `window` or `document`); code testing (a test framework injecting code and controlling injection order, with tests running autonomously without conflicting); codebase segmentation (isolating legacy from new code per ShadowRealm to preserve intrinsic integrity, where resolving a global-variable conflict by modifying a large codebase is non-trivial); template libraries; and DOM virtualization, with two concrete blockers, the AMP WorkerDOM challenge that `Element.getBoundingClientRect()` cannot work over an asynchronous channel and that functions and Proxy objects are not transferable, and JSDOM's dependence on Node's `vm` plus a hand-maintained vm shim for bundled use. The status quo is `vm` in Node and same-domain iframes in browsers; `vm` is called "a very good approximation", iframes are "problematic" for four specific reasons: the iframe global is a window proxy with a bizarre unforgeable proto chain, DOM semantics make multiple objects unvirtualizable so capabilities cannot be eliminated cleanly, `top` cannot be redefined and leaks a reference to another global (nulling it requires detaching the iframe, which then restricts dynamic `import()`), and cross-realm objects are exposed with identity discontinuity. The virtualized-environment section adds a demonstration that a ShadowRealm's global can simply be frozen, while `Object.freeze(iframe.contentWindow)` throws a `TypeError` on the window proxy.

## Use cases

**Third party scripts.** Applications need quick and simple execution of code, often many scripts for the same application, with no need for a new host or agent. This is not aimed at defending against malicious code or XSS injection; the focus is multi-library building blocks from different authors that conflict with each other. Third-party scripts can be executed non-blockingly through `ShadowRealm#importValue()`, and there is no need for immediate access to application globals such as `window` and `document`.

```javascript
const shadowRealm = new ShadowRealm();
const [ init, ready ] = await Promise.all([
    shadowRealm.importValue('./pluginFramework.js', 'init'),
    shadowRealm.importValue('./pluginScript.js', 'ready'),
]);
init(ready);
```

**Code testing.** Test frameworks can use a ShadowRealm to inject code and control injection order, with testing code running autonomously within the boundaries the ShadowRealm sets, without immediately conflicting with other tests.

```javascript
import { test } from 'testFramework';
const shadowRealm = new ShadowRealm();
const [ runTests, getReportString, suite ] = await Promise.all([
    shadowRealm.importValue('testFramework', 'runTests'),
    shadowRealm.importValue('testFramework', 'getReportString'),
    shadowRealm.importValue('./my-tests.js', 'suite'),
]);
runTests(suite);
getReportString('tap', res => console.log(res));
```

**Codebase segmentation.** A big codebase evolves slowly and becomes legacy; resolving a conflict such as a shared global variable by modifying code is non-trivial in a large codebase. A ShadowRealm gives a lightweight mechanism to preserve intrinsic integrity, isolating libraries or logical pieces of the codebase per realm.

**DOM virtualization.** Applications want DOM interaction without excessive resource cost, and emulating the DOM as faithfully as possible matters because requiring authors (especially third-party library authors) to change their code for a virtualized environment is difficult.

- *AMP WorkerDOM challenge*: `Element.getBoundingClientRect()` does not work over asynchronous communication channels such as [worker-dom](https://github.com/ampproject/worker-dom). Communication is further limited by the serialization constraints of [transferable objects](https://html.spec.whatwg.org/multipage/structured-data.html#transferable-objects): functions and Proxy objects are not transferable.
- *JSDOM plus vm modules*: JSDOM relies on `vm` to emulate `HTMLScriptElement` and maintains a shim of the vm module for bundled use in a webpage without access to Node's `vm`. The ShadowRealm API provides a single API for this virtualization in both browsers and Node.js.

**Virtualized environment and DOM mocking.** Different realms allow customized access to the global environment. To start, the global object can be frozen immediately, either by `evaluate` or, without relaxing CSP, by importing a function that freezes its own `globalThis`. DOM mocking becomes a userland `installFakeDOM()` that defines `document`, `Element`, `Node`, and the rest as descriptors backed by Proxies over the incubator's objects, avoiding the problem of immutable accessors on the window proxy such as `window.top` and `window.location`. The explainer marks its `installFakeDOM` sketch as speculative, with room for improvement.

## Status quo, and why iframes are problematic

> The current status quo is using VM module in nodejs, and same-domain iframes in browsers. Although, VM modules in node is a very good approximation to this proposal, iframes are problematic.

Developers can technically create a new realm with a same-domain iframe, but four impediments make it unreliable:

- the global object of the iframe is a window proxy, which implements a bizarre behavior, including its unforgeable proto chain;
- there are multiple unvirtualizable objects due to DOM semantics, making it almost impossible to eliminate certain capabilities while downgrading the window to a brand-new global without DOM;
- the global `top` reference cannot be redefined and leaks a reference to another global object; the only way to null out this behavior is to **detach** the iframe, which restricts dynamic `import()` calls (and the `top` accessor still exists after detaching, now returning null);
- cross-realm objects are exposed with identity discontinuity.

The identity-discontinuity contrast is shown directly: with an iframe, `iframeArray !== Array`, `list instanceof Array` is false, and `[] instanceof iframeArray` is false. "This code is **not** possible with the ShadowRealm API! Non-primitive values are not transfered cross-realms using the ShadowRealm API."

Against Node's `vm`, `new vm.Script(...).runInContext(vm.createContext())` becomes `shadowRealm.evaluate(...)`, with the caveat that the two are "rough equivalents in functionality only" since `vm` retains extended capabilities and ergonomics.

## FAQ

- **Only ECMAScript APIs?** It creates a new copy of the ECMAScript built-ins; the host can add other APIs, and there are open discussions about additional HTML properties or an intrinsics subset.
- **Can I run code securely?** "It depends on what kind of security protections are required", pointing at the Security section.
- **Most libraries will not work unless dependencies are added manually.** Acknowledged, and held equivalent to Node's `vm` as low-level prior art: as a developer you set up the environment to execute code. "Ideally the ShadowRealms would arrive a clean state, allowing tailoring for what is necessary to be added. This contrasts with the tailoring over unforgeables." Considering the tradeoffs, the clean state is held to be the best option.
- **Exploration ahead.** More is left to explore, but the current API is "good enough to enable synchronous execution of code and membranes implementation, even if setup might require async import for code injection."

Source: [proposal-shadowrealm/explainer.md](https://github.com/tc39/proposal-shadowrealm/blob/main/explainer.md) at content sha256 `4842a1ef`. Stage 2.7; retrieved 2026-07-29.
