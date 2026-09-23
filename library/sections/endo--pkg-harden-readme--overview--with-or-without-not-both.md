---
title: With _or_ Without _not_ Both
source: packages/harden/README.md
source_repo: endojs/endo
source_commit: 20a61e3d
source_date: 2025-10-10
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
parent: endo--pkg-harden-readme--overview
---

Hardened modules calling `harden` should be fine at any time in an application
that never calls `lockdown` or `repairIntrinsics`.

However, initializing a hardened module before setting up a HardenedJS
environment (before calling `lockdown`) and then proceeding on the assumption
that it's hardened after `lockdown` would leave the apparently-hardened module
vulnerable.

So, `@endo/harden` arranges for `lockdown()` and `repairIntrinsics()` to throw
an exception with a _helpful_ stack if `harden` gets called before
either one.
The stack points to the module that was initialized before `lockdown`
and which should be moved after `lockdown`.
The `lockdown` call often occurs as a side-effect of initializing
`@endo/lockdown`, `@endo/init`, or by convention, modules with names like
`prepare-*`.

Source: [packages/harden/README.md](https://github.com/endojs/endo/blob/20a61e3d/packages/harden/README.md) at commit `20a61e3d`.
