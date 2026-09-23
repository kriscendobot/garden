---
title: Translation block (comment idiom → contemporary practice)
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "212-end (tameV8ErrorConstructor function and exports)"
topics: [hardened-javascript, errors, capability-security]
status: current
parent: endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns
---

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `tameV8ErrorConstructor` four-argument entry point | The *taming function* idiom across SES: `tame*` functions install defensive replacements for engine intrinsics. |
| System-vs-user prepareFn distinction | The *who-can-see-what* discipline at the capability-attenuation layer. |
| WeakSet branding for system prepareFns | Prevents double-wrapping; preserves identity round-trip for read-then-assign cycles. |
| `__HIDE_` function-name censor | Application-code convention for *hide this frame*; the function-name-prefix is the marker. |
| Lazy stringification via `void error.stack` | Trigger V8's internal `prepareStackTrace` synchronously without consuming the result. |
| `getStackString` as proposed TC39 special-power | The *Error Stacks* proposal capability; SES makes this start-compartment-only. |
| `errorTaming === 'unsafe'` mode | The debug-friendly mode that exposes stacks; default-off because stack-frame inspection is a capability leak. |
| Accessor-pair setter that wraps via brand-check | Transparent-wrapper-with-identity-preservation pattern. |
