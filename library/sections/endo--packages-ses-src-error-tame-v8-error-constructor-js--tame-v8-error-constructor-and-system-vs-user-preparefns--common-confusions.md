---
title: Common confusions
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

- **"User prepareFns are restricted — what if they need the full SST?"** Then they need to be a system prepareFn, which only this module can create. Application code is *intentionally* prevented from seeing the unattenuated SST because it can leak capabilities (function-objects via `getFunction`, receivers via `getThis`). The restriction is the *point* of the design.
- **"`__HIDE_` is a magic string."** It is — and it's *documented* magic. The convention is part of the contract: name your hidden functions with the prefix, and they're censored from concise stacks. The prefix is unusual enough that accidental matches are vanishingly unlikely.
- **"WeakSet branding is overkill."** Without it, re-assigning `Error.prepareStackTrace` via `Error.prepareStackTrace = Error.prepareStackTrace` would double-wrap. With it, the second assignment is a no-op. The WeakSet check is cheap; the alternative (re-wrap every time) would create unbounded layers.
- **"`void error.stack` is a code smell."** It is *intentional* — the side effect (triggering V8's `prepareStackTrace`) is exactly what we want; the result (the stack string in safe mode is `''`) is uninteresting. The `void` operator is the standard JavaScript way to *evaluate-for-side-effect-only*.
- **"`errorTaming: 'unsafe'` defeats the whole point."** It exposes stacks to user code, but it does *not* expose `getThis` / `getFunction` (the suppressed methods stay suppressed). The unsafe mode is a debugging convenience that retains the most-load-bearing capability-attenuation.
- **"The accessor-pair setter could be simpler."** The brand-check is *required* to prevent double-wrapping; the wrapping is *required* to attenuate the SST seen by user prepareFns. The pair's complexity is the *minimum* to achieve both.
- **"The shim of TC39 error-stacks proposal is speculative."** The proposal is mature (at stage 3-ish as of paper-writing). The shim ensures SES is forward-compatible: when the proposal lands as standard, SES's `getStackString` will already match the spec. Until then, the shim provides the same capability with a clear migration path.
