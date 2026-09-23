---
title: With HardenedJS
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

The package `@endo/harden` reexports `Object[Symbol.for('harden')]` or
`globalThis.harden` in its execution environment, in order of preference.
It is suitable regardless of whether a module is used with or without
HardenedJS.

When using SES, `lockdown` creates `globalThis.harden` in the Realm's
intrinsic `globalThis` and also automatically endows `globalThis.harden`
to any `Compartment`.
It is possible to delete `globalThis.harden` on new compartments.
However, every version of SES published since the introduction of `@endo/harden`
also provides `Object[Symbol.for('harden')]`, which is a property of one
of the hardened shared intrinsics and cannot be subverted in a compartment.

The `harden` in `@endo/harden` prefers `Object[Symbol.for('harden')]`
because endowments cannot override that intrinsic.
Any multi-tenant `Compartment` should freeze its own `globalThis`, including
making `harden` non-configurable and non-writable, so there is no risk
of tampering.

When creating a bundle for an application that can safely assume it will run in
a HardenedJS environment, consider passing the build condition `-C hardened`.
This will provide the smallest version of `@endo/harden`, one which will throw
an exception if `harden` is not present.

```
bundle-source -C hardened entry.js > entry.json
```

Source: [packages/harden/README.md](https://github.com/endojs/endo/blob/20a61e3d/packages/harden/README.md) at commit `20a61e3d`.
