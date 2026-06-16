---
title: §Registered-symbol-protocol-as-cross-module-coordination
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

```js
const MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA = Symbol.for(
  'MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA',
);

const optMakeCausalConsoleFromLoggerForSesAva =
  globalThis[MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA];
```

§Registered-symbol-on-globalThis as the cross-module coordination shape. The §protocol-is-named-explicitly-in-the-symbol-name (`_FOR_SES_AVA` suffix). §The-comment-is-honest-about-what-this-is:

> Thus, the SES console-shim.js makes `makeCausalConsoleFromLoggerForSesAva` available on `globalThis` which it *assumes* is the global of the start compartment and is therefore allowed to hold powers that should not be available in constructed compartments.

§Three-cycles-of-cross-module-coordination-protocols now in library:

| Cycle | Source | Mechanism |
| --- | --- | --- |
| 197 | @endo/panic | §registered-symbol-as-emulated-private-state |
| 217 | @endo/errors | §`__HIDE_`-prefix-protocol via name-prefix |
| 219 | @endo/ses-ava | §registered-symbol-on-globalThis as privileged-API |

§Three-different-shapes-for-cross-module-coordination. §The-pattern: §when-two-modules-must-coordinate-without-direct-import, §use-a-shared-string-or-symbol-as-the-protocol.
