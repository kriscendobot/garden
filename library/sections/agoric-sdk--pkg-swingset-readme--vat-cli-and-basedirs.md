---
title: vat CLI (run / shell / basedirs)
source: packages/SwingSet/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d95438c0888b5f7e903e258013d30b66f2458cf
source_date: 2025-10-25
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, bundles]
status: current
notes: The bootstrap-vat singleton-entry-point pattern is the canonical mechanism for getting anything to happen in a SwingSet — without it, all vats are born without external references and nothing can be invoked.
---

> Abstract: The in-package `vat` CLI. Two modes: `bin/vat run --config <swingset-config>` and `bin/vat shell --config <swingset-config>` (REPL with `dump()` / `await step()` / `await run()` added to the environment). A basedir-style invocation is also supported: every `vat-*.js` (or `vat-*/index.js`) under the basedir creates a Vat. A `bootstrap.js` is mandatory: it defines the "bootstrap Vat" whose `bootstrap(argv, vats)` method is invoked at startup with the argv array and a `vats` object holding Presences of every other Vat's root object. The bootstrap invocation is the **only** way to get things started — all other Vats are born without external references; they may run setup code but cannot interact without Presences.

## `vat` CLI

```console
$ yarn install
$ bin/vat run --config demo/encouragementBot/swingset.json
```

### REPL Shell

```console
$ bin/vat shell --config demo/encouragementBot/swingset.json
vat>
```

Shell mode gives you an interactive REPL, just like running `node` without arguments. All vats are loaded, and three additional commands are added to the environment:

* `dump()`: display the kernel tables, including the run queue
* `await step()`: execute the next action on the run queue
* `await run()`: keep stepping until the run queue is empty

### Vat Basedirs

`vat` must be called with either a SwingSet configuration file (as above) or a "basedir" argument containing sources for all the Vats that should be loaded.

Every file named `vat-*.js` (e.g. `vat-foo.js` and `vat-bar-none.js`) will create a new Vat (with names like `foo` and `bar-none`). Each directory named `vat-*/` that has an `index.js` will also create a new Vat (e.g. `vat-baz/index.js`).

In addition, a file named `bootstrap.js` must be present. This will contain the source for the "bootstrap Vat", which behaves like a regular Vat except:

* At startup, its `bootstrap` method will be invoked, as `bootstrap(argv, vats)`
* The `argv` value will be an array of strings from the command line. So running `bin/vat BASEDIR -- x1 x2 x3` will set `argv = ['x1', 'x2', 'x3']`.
* The `vats` value will be an object with keys named after the other Vats that were created, and values which are each a Presence for that Vat's root object. This allows the bootstrap Vat to invoke the other Vats, and wire them together somehow.

The `bootstrap()` invocation is the only way to get anything started: all other Vats are born without external references, and nothing can be invoked without an external reference. Those Vats can execute code during their `setup()` phase, but without Presences they won't be able to interact with anything else.

Source: [packages/SwingSet/README.md](https://github.com/Agoric/agoric-sdk/blob/7d95438c0888b5f7e903e258013d30b66f2458cf/packages/SwingSet/README.md) at commit `7d95438c`.
