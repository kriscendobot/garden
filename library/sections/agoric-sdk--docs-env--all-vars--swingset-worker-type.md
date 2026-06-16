---
title: SWINGSET_WORKER_TYPE
source: docs/env.md
source_repo: agoric/agoric-sdk
source_commit: 8051bed260133080a0d46339aefcc9baba5c1d34
source_date: 2026-03-31
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [tooling, repository-governance, errors]
status: current
parent: agoric-sdk--docs-env--all-vars
---

Affects: solo, unit tests

Purpose: select the default Worker type (default `local`)

Description: The SwingSet kernel launches each vat into a "worker" of a
particular type. The `local` workers run in the same Node.js process as the
kernel (which facilitates debugging). The `xsnap` workers run in a child
process under the XS engine (which provides metering and heap snapshots, as
well as more consistent GC behavior). `xs-worker` is an alias for `xsnap`.

Applications and unit tests may specify which type of worker they use for all
vats in their `config.defaultManagerType` record, especially if they need a
specific type for some reason. If they do not specify it there, the environment
variable will supply a default. The full hierarchy of controls are:

* config.vats.NAME.creationOptions.managerType (highest priority, but
                                                only for static vats)
* config.defaultManagerType (applies to both static and dynamic vats)
* env.SWINGSET_WORKER_TYPE
* use a 'local' worker (lowest priority)

The environment variable exists so CI commands (e.g. 'yarn test:xs') can run a
batch of unit tests under a different worker, without editing all their config
records individually. `config.defaultManagerType` has a higher priority so that
tests which require a specific worker (e.g. which exercise XS heap snapshots,
or metering) can override the env var, so they won't break under `yarn
test:xs`.

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
