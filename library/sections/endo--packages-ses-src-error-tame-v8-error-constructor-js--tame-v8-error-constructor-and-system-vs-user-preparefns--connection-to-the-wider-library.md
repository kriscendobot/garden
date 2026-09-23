---
title: Connection to the wider library
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

This section is the **canonical worked example of *system-vs-user-prepareFn distinction* via WeakSet branding** at the SES V8-taming layer. Three threads:

1. **The system-vs-user-prepareFn distinction** is reusable for any *capability-wrapping API* where user code can assign callbacks that should not see the full unattenuated input. The WeakSet branding prevents double-wrapping on read-back-and-re-assign cycles.

2. **The accessor-pair-as-transparent-wrapper pattern**. Getter returns the current installed function (preserving identity); setter wraps if needed. From the user's perspective, the API behaves like a plain property; the wrapping is invisible until something breaks the brand-check.

3. **The `__HIDE_` function-name convention**. Functions whose name starts with `__HIDE_` are dropped from concise stacks. The convention generalizes — any application can use this prefix to hide instrumentation, decorators, or test scaffolding from debugging output.
