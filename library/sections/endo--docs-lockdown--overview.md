---
title: Lockdown (overview)
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: The lockdown() API and its option taxonomy: 14 safety-vs-compatibility options whose defaults are 'safe' plus environment-variable fallthroughs (LOCKDOWN_*). Tables map each option to its settings, env var, and details link. The tradeoff framing: safety vs compatibility, though a tremendous amount of legacy code runs compatibly under SES even with all options at 'safe'. mathTaming and dateTaming are deprecated; Math.random and Date.now are disabled in compartments and must be injected as endowments.

# Lockdown

See the
[README](https://github.com/endojs/endo/blob/master/packages/ses/README.md) for
a description of the global `lockdown` function installed by the SES-shim.
Essentially, calling `lockdown` turns a JavaScript system into a SES system,
with enforced ocap (object-capability) security.
Here we explain the configuration options to the lockdown function.

# `lockdown` Options

For every safety-relevant options setting, if the option is omitted
it defaults to `'safe'`. For these options, the tradeoff is safety vs
compatibility, though note that a tremendous amount of legacy code, not
written to run under SES, does run compatibly under SES even with all of these
options set to `'safe'`. You should only consider an `'unsafe'` option if
you find you need it and are able to evaluate the risks.

The `stackFiltering` option trades off stronger filtering of stack traceback to
minimize distractions vs completeness for tracking down a bug hidden in
obscure places. The `overrideTaming` option trades off better code
compatibility vs better tool compatibility.

Each option is explained in its own section below.

| option                           | default setting  | other settings                         | about |
|----------------------------------|------------------|----------------------------------------|-------|
| `regExpTaming`                   | `'safe'`         | `'unsafe'`                             | `RegExp.prototype.compile` ([details](#regexptaming-options)) |
| `localeTaming`                   | `'safe'`         | `'unsafe'`                             | `toLocaleString`           ([details](#localetaming-options)) |
| `consoleTaming`                  | `'safe'`         | `'unsafe'`                             | deep stacks                ([details](#consoletaming-options)) |
| `errorTaming`                    | `'safe'`         | `'unsafe'` `'unsafe-debug'`            | `errorInstance.stack`      ([details](#errortaming-options)) |
| `errorTrapping`                  | `'platform'`     | `'exit'` `'abort'` `'report'` `'none'` | handling of uncaught exceptions ([details](#errortrapping-options)) |
| `reporting`                      | `'platform'`     | `'console'` `'none'`                   | where to report warnings ([details](#reporting-options))
| `unhandledRejectionTrapping`     | `'report'`       | `'none'`                               | handling of finalized unhandled rejections ([details](#unhandledrejectiontrapping-options)) |
| `evalTaming`                     | `'safe-eval'`    | `'unsafe-eval'` `'no-eval'`            | `eval` and `Function` of the start compartment ([details](#evaltaming-options)) |
| `stackFiltering`                 | `'concise'`      | `'omit-frames'` `'shorten-paths'` `'verbose'`  | deep stacks signal/noise   ([details](#stackfiltering-options)) |
| `overrideTaming`                 | `'moderate'`     | `'min'` or `'severe'`                  | override mistake antidote  ([details](#overridetaming-options)) |
| `overrideDebug`                  | `[]`             | array of property names                | detect override mistake    ([details](#overridedebug-options)) |
| `domainTaming`                   | `'safe'`         | `'unsafe'`                             | Node.js `domain` module    ([details](#domaintaming-options)) |
| `legacyRegeneratorRuntimeTaming` | `'safe'`         | `'unsafe-ignore'`                      | regenerator-runtime ([details](#legacyregeneratorruntimetaming-options)) |
| `__hardenTaming__`               | `'safe'`         | `'unsafe'`                             | Making `harden` no-op for performance in trusted environments ([details](#__hardentaming__-options)) |

In the absence of any of these options in lockdown arguments, lockdown will
attempt to read these options from `process.env`, using the Node.js convention
for threading environment variables into a JavaScript program.

| option                           | environment variable                         | notes                 |
|----------------------------------|----------------------------------------------|-----------------------|
| `regExpTaming`                   | `LOCKDOWN_REGEXP_TAMING`                     |                       |
| `localeTaming`                   | `LOCKDOWN_LOCALE_TAMING`                     |                       |
| `consoleTaming`                  | `LOCKDOWN_CONSOLE_TAMING`                    |                       |
| `errorTaming`                    | `LOCKDOWN_ERROR_TAMING`                      |                       |
| `errorTrapping`                  | `LOCKDOWN_ERROR_TRAPPING`                    |                       |
| `reporting`                      | `LOCKDOWN_REPORTING`                         |                       |
| `unhandledRejectionTrapping`     | `LOCKDOWN_UNHANDLED_REJECTION_TRAPPING`      |                       |
| `evalTaming`                     | `LOCKDOWN_EVAL_TAMING`                       |                       |
| `stackFiltering`                 | `LOCKDOWN_STACK_FILTERING`                   |                       |
| `overrideTaming`                 | `LOCKDOWN_OVERRIDE_TAMING`                   |                       |
| `overrideDebug`                  | `LOCKDOWN_OVERRIDE_DEBUG`                    | comma separated names |
| `domainTaming`                   | `LOCKDOWN_DOMAIN_TAMING`                     |                       |
| `legacyRegeneratorRuntimeTaming` | `LOCKDOWN_LEGACY_REGENERATOR_RUNTIME_TAMING` |                       |
| `__hardenTaming__`               | `LOCKDOWN_HARDEN_TAMING`                     |                       |

The options `mathTaming` and `dateTaming` are deprecated.
`Math.random`, `Date.now`, and the `new Date()` are disabled within
compartments and can be injected as `globalThis` endowments if necessary, as in
this example where we inject an independent pseudo-random-number generator in
this single-tenant compartment.

```js
new Compartment({
  Math: harden({
    ...Math,
    random: harden(makeRandom(seed)),
  }),
})
```


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
