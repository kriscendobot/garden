---
title: §AbstractModuleSource for forward-compatibility (the most novel architectural move)
source-slug: endo--packages-module-source
section-id: ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
url: https://github.com/endojs/endo/tree/master/packages/module-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/module-source/src/{module-source.js, transform-analyze.js, transform-source.js, babel-plugin.js, parse-babel.js, hidden.js}
status: shipping
ingest-cycle: 223
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-module-source--ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
---

```js
function AbstractModuleSource() {
  // no-op, safe to super()
}

Object.setPrototypeOf(ModuleSource, AbstractModuleSource);
Object.setPrototypeOf(ModuleSource.prototype, AbstractModuleSource.prototype);

freeze(AbstractModuleSource);
freeze(AbstractModuleSource.prototype);
freeze(ModuleSource.prototype);
freeze(ModuleSource);
```

§The-prototype-chain-bridge anticipates the TC39 Source Phase Imports proposal, which would introduce a native `AbstractModuleSource` as a superclass of both `ModuleSource` and `WebAssembly.Module`. §The-shim-installs-an-intermediate-prototype-`AbstractModuleSource`-now-so-future-code-that-relies-on-its-existence-works.

§The-honest-disclosure-comment:

> We are attempting to ensure that a JavaScript shim (particularly ses) is forward-compatible as the engine evolves beneath it, with or without this ModuleSource shim, and with our without a native AbstractModuleSource which remains undecided. Lockdown does not gracefully handle the presence of an unexpected prototype, but can tolerate the absence of an expected prototype. So, we are providing AbstractModuleSource since we can better tolerate the various uncertain futures.

§Lockdown-can-tolerate-absence-but-not-presence-of-unexpected-prototype. §The-design-bet: §install-the-AbstractModuleSource-prototype-now-because-its-absence-can-be-tolerated-but-its-unexpected-presence-cannot. §When-the-native-version-arrives, §the-engine-may-replace-this-one + §the-existing-callers-keep-working.

§Borrowable-pattern: §the-asymmetric-tolerance-discipline — §when-future-evolution-could-go-multiple-ways + §one-direction-tolerates-the-shim + §the-other-direction-doesn't, §pick-the-shape-that-tolerates-both.

§Sibling to cycle 201 @endo/immutable-arraybuffer's §ponyfill+shim — both designs anticipate future native arrival. §Cycle-201 races to install + cycle-223 installs the prototype unconditionally + §two-different-future-arrival-shapes.

### §The-WebAssembly.Module-entanglement-deferred

> WebAssembly and ModuleSource are both in motion. The Source Phase Imports proposal implies an additional AbstractModuleSource layer above the existing WebAssembly.Module that would be shared by the JavaScript ModuleSource prototype chains. At time of writing, no version of WebAssembly provides the shared base class, and the ModuleSource *shim* gains nothing from sharing one when that prototype when it comes into being. So, we do not attempt to entangle our AbstractModuleSource with WebAssembly.Module.

§Honest-acknowledgment-of-what-the-shim-could-have-done-but-doesn't. §Borrowable-pattern: §name-the-temptation-and-resist-it-with-rationale. §The-design-doesn't-secretly-leave-out-WebAssembly-entanglement; §it-says-explicitly-why.
