---
title: Usage: Logging Errors and Controlling Module-Loading Errors
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, errors]
status: current
---

> Abstract: Two error-handling sub-sections under Usage: Logging Errors describes how the tamed causal console interacts with thrown errors; Controlling Module-Loading Errors covers Compartment-level error policies for failed module resolution. Both are short H3 sub-sections consolidated as one section.

### Logging Errors

`lockdown()` adds new global `assert` and tames the global `console`. The error
taming hides error stacks, accumulating them in side tables. The `assert`
system generates other diagnostic information hidden in side tables. The tamed
console uses these side tables to output more informative diagnostics.
[Logging Errors](../../docs/errors.md) explains the design.

### Controlling Module-Loading Errors

The `Compartment` constructor now accepts a `boolean` option, `noAggregateLoadErrors`, to control how module-loading errors are reported.

By default, its value is `false`, which causes all relevant errors to be collected and rejected or thrown in a single exception from `compartment.import()` or `compartment.importNow()`, respectively.

If set to `true`, this will cause the *first* module-loading error encountered to be thrown (or rejected) immediately; no further module-loading will be attempted, and no further errors will be collected.

This is mostly useful for supporting optional dependencies in CommonJS modules, for example:

```js
try {
  require('something-optional')
} catch (err) {
  // continue
}
```


Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md) at commit `fe81477b`.
