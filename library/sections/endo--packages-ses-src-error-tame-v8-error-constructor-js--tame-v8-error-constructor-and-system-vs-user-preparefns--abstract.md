---
title: Abstract
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

The §closing cluster of `tame-v8-error-constructor.js` is the `tameV8ErrorConstructor` function — the *taming* operation that installs SES's defensive stack-trace handling onto V8's Error constructor. The function takes four arguments: `OriginalError` (the realm's intrinsic Error), `InitialError` (SES's tamed Error), `errorTaming` (one of `'safe'`, `'unsafe'`, `'unsafe-debug'`), and `stackFiltering` (one of `'concise'`, `'omit-frames'`, `'shorten-paths'`). The function refuses `'unsafe-debug'` (the special case is handled elsewhere). The structural payload is the **system-vs-user prepareFn distinction**: V8 invokes `Error.prepareStackTrace(error, structuredStackTrace)` whenever an error's `.stack` is read, and the prepareStackTrace return value becomes the displayed `.stack`. A *user prepareFn* (assigned by application code) should only see an *attenuated SST* (an array of `safeV8CallSiteFacet`-wrapped frames per §1's permit list); a *system prepareFn* (defined by this module) sees the original unattenuated SST and is the only one allowed to do so. The distinction is enforced by a **`systemPrepareFnSet` WeakSet** that *brands* every system prepareFn the module creates. When application code assigns `Error.prepareStackTrace = userFn`, the setter wraps `userFn` in a new system prepareFn (`systemPrepareFnFor(userFn)`) that stores the original SST in `stackInfos`, then calls `userFn` with the *safe* SST. The `tamedMethods.captureStackTrace` shim either delegates to the original V8 `captureStackTrace` (cutting off the bottom frame by default) or, on non-V8 engines, sets `error.stack = ''`. The `tamedMethods.getStackString` function is *the shim of the proposed special power* for getting the stack-traceback-string associated with an error — pointing to `tc39.es/proposal-error-stacks/`. The function returns the cached `stackString` from `stackInfos` if present; otherwise reads `error.stack` to populate `stackInfos` (calling `prepareStackTrace` synchronously), then formats from the cached SST via `stackStringFromSST`. Under `errorTaming === 'unsafe'`, the default `prepareStackTrace` produces a stack string directly (matching V8's normal behavior); otherwise it stores the SST and returns the empty string (the error has no readable stack at the JavaScript layer).
