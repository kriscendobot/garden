---
title: overrideDebug Options
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

> Abstract: Array of property names to actively detect override-mistake violations against. Default: empty array. When set, override attempts on the named properties throw with a diagnostic instead of silently failing. Useful for debugging code that hits taming-related errors during SES migration.

## `overrideDebug` Options

To help diagnose problems with the [Property Override Mistake][POM], you can
set this option to a list of properties that will print diagnostic information
when their override enablement is triggered.

  [POM]: https://github.com/endojs/endo/discussions/1855

For example, to find the client code that causes a `constructor` property override
mistake, set the options as follows:

```js
{
  overrideTaming: 'severe',
  overrideDebug: ['constructor']
}
```

If `lockdown` does not receive an `overrideDebug` option, it will respect
`process.env.LOCKDOWN_OVERRIDE_DEBUG`, a comma-separated list of property names
on shared intrinsics to replace with debugger accessors.

```console
LOCKDOWN_OVERRIDE_DEBUG=constructor,toString
```

The idiom for `@agoric/install-ses` when tracking down the override
mistake with the `constructor` property is to set the following
environment variable:

```sh
LOCKDOWN_ERROR_TAMING=unsafe \
LOCKDOWN_STACK_FILTERING=verbose \
LOCKDOWN_OVERRIDE_TAMING=severe \
LOCKDOWN_OVERRIDE_DEBUG=constructor \
node ...
```

Then, when some script deep in the require stack does:

```js
function MyConstructor() { }
MyConstructor.prototype.constructor = XXX;
```

the caller backtrace will be logged to the console, such as:

```
(Error#1)
Error#1: Override property constructor

  at Object.setter (packages/ses/src/enable-property-overrides.js:114:27)
  at packages/ses/test/override-tester.js:26:19
  at overrideTester (packages/ses/test/override-tester.js:25:9)
  at packages/ses/test/test-enable-property-overrides-severe-debug.js:14:3
```


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
