---
title: Supporting multiple configurations
source: packages/ses-ava/README.md
source_repo: endojs/endo
source_commit: 2845b6bd385c185893f6c9267a946bed6c65bf37
source_date: 2025-10-29
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [testing, hardened-javascript]
status: current
---

> Abstract: How a single test file can exercise multiple SES configurations (different lockdown option combinations). Pattern: parameterized test wrappers that re-run the same body under each configuration; tooling for distinguishing the configurations in test output.

# Supporting multiple configurations

SES-AVA also provides a command line tool, `ses-ava`, that can run AVA with
multiple configurations in a single command, intercepting flags to filter
for interesting configurations.
The `ses-ava` command consumes the `"ava"` and (new) `"sesAvaConfigs"` properties
in `package.json` to discover and name the supported configurations which can be
referenced by `--only` and `--exclude` options (and their respective `-o` and
`-x` shorthands), where the `"ava"` configuration is the `default`, if present.

With appropriate configurations, packages can run many of the same tests
with or without an initialized Endo environment.
This is useful for Endo's _Hardened Modules_: modules that use `harden` to
defend the integrity of their interface, with varying degrees of defense depending
on whether they're used in composition with HardenedJS's `lockdown`.

For tests that might be used regardless of the environment, SES-AVA provides
an `@endo/ses-ava/test.js` module.
It exports the `test` from `ava` by default.
But with the `node` condition `ses-ava:endo`, it exports a wrapped `test`
that unredacts errors, so tests see the original error messages that would
otherwise be redacted by SES's Assert machinery.

```js
import test from '@endo/ses-ava/test.js';
```

SES-AVA then enables different AVA configurations to set up different
environments.
For example, the `lockdown` configuration might look like:

```js
export default {
  require: ['@endo/ses-ava/prepare-endo-config.js'],
  nodeArguments: ['-C', 'ses-ava:endo']
};
```

This relies on SES-AVA  to initialize an
Endo environment, including the SES shims and Eventual Send shim, and also
register the SES-AVA wrapped `test` declarator, which can unredact error
messages produced by the Assert shim from SES.
If the test doesn't import `@endo/ses-ava/test.js`, requiring
`@endo/ses-ava/prepare-endo-config.js` ensures the environment is fully
initialized.
In the root of the Endo repository, look at the `ava-*.config.mjs` modules
for example configurations.

Then, in `package.json`, we can use `ses-ava` instead of `ava`.

```json
{
  "scripts": {
    "test": "ses-ava",
    "test:c8": "c8 ${C8_OPTIONS:-} ses-ava"
  },
  "avaConfigs": {
    "lockdown": "test/_ava-lockdown.config.mjs",
    "unsafe": "test/_ava-lockdown-unsafe.config.mjs",
  }
}
```

With this configuration, `ses-ava ...args --exclude lockdown` and `ses-ava
...args --only unsafe` would both just run the `unsafe` configuration.
Using `ses-ava` under `c8` allows all configurations to cover used code.


Source: [packages/ses-ava/README.md](https://github.com/endojs/endo/blob/2845b6bd385c185893f6c9267a946bed6c65bf37/packages/ses-ava/README.md) at commit `2845b6bd`.
