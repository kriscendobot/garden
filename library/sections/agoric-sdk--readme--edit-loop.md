---
title: Edit Loop
source: README.md
source_repo: agoric/agoric-sdk
source_commit: 511d4f74bae7144be5bc904dd7a50f01d09648ed
source_date: 2026-03-25
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling]
status: current
notes: The "yarn build in zoe creates the contract facet bundle" point is a non-obvious gotcha — editing a Zoe contract without running `yarn build` means the rebuilt source is *not* what `zoe~.install(...)` will see. Bundle-source / compartment-mapper context lives in endo--pkg-bundle-source-readme and endo--pkg-compartment-mapper-readme.
---

> Abstract: The agoric-sdk inner-loop iteration: modify code in e.g. `zoe/`, run `yarn build` (top-level or in `zoe/`), re-run tests or `agoric start --reset`, repeat. Important caveat: doing `yarn build` in `zoe` creates the "contract facet bundle" — a single file rolled up from all Zoe contract vat sources. This bundle is what `zoe~.install(...)` invokes, so without `yarn build` your edits to the Zoe contract facet are ignored.

## Edit Loop

* modify something in e.g. `zoe/`
* run `yarn build` (at the top level or in `zoe/`)
* re-run tests or `agoric start --reset`
* repeat

Doing a `yarn build` in `zoe` creates the "contract facet bundle", a single file
that rolls up all the Zoe contract vat sources. This bundle file is needed by
all zoe contracts before they can invoke `zoe~.install(...)`. If you don't run
`yarn build`, then changes to the Zoe contract facet will be ignored.

Source: [README.md](https://github.com/Agoric/agoric-sdk/blob/511d4f74bae7144be5bc904dd7a50f01d09648ed/README.md) at commit `511d4f74`.
