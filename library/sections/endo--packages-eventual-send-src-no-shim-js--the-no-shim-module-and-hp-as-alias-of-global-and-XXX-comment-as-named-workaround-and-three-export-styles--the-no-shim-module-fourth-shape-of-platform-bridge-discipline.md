---
title: §The no-shim module — fourth shape of platform-bridge discipline
source-slug: endo--packages-eventual-send-src-no-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles
---

```js
const hp = HandledPromise;
```

§The-no-shim-module assumes the platform shim has already installed `HandledPromise` globally. §No-shim-IS-the-consumer-side of the pony-shim split. §When-the-application-knows-the-shim-has-already-installed-the-global, §use-the-no-shim-module + §skip-the-installation-step.

§Four-cycles-with-platform-bridge-discipline now: §cycle-188 monkey-patch-the-platform-shape + §cycle-242 elevator-module + §cycle-245 pony-shim (installs onto platform prototype) + §cycle-254 no-shim (consumes already-installed global). §Four-different-shapes-of-platform-bridge — each shape trades off differently.

§The-no-shim-and-pony-shim-are-complements: §the-pony-shim installs the global + §the-no-shim assumes it's been installed + §the-application chooses which entrypoint to import. §When-shipping-a-library-that-uses-a-global, §provide-both-a-shim-and-a-no-shim-entrypoint + §let-the-consumer-choose-installation-responsibility.

§First-explicit-observation in library of §the-no-shim-module-as-counterpart-to-the-pony-shim as named architecture-pattern.
