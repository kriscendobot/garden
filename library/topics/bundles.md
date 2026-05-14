# Topic: bundles

> Abstract: How Endo packages module graphs into self-contained units. Covers Compartment module loading (descriptors, redirects, lookup hooks, virtual sources, compiled modules, transforms) and the bundle-source / compartment-mapper / import-bundle / module-source packages that compose the bundling layer. Distinct from `compartments` (the isolation primitive) and from `hardened-javascript` (the substrate).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--pkg-ses-readme--usage-modules](../sections/endo--pkg-ses-readme--usage-modules.md) | endo packages/ses/README.md | Compartment module loading: descriptors, redirects, hooks, virtual sources, compiled modules, transforms. |
| [agoric-sdk--readme--build](../sections/agoric-sdk--readme--build.md) | agoric-sdk README.md | yarn install + yarn build produces "kernel bundles"; node_modules workspace symlink behavior. |

> Note: this topic page is incomplete (25 sections claim `bundles` but only 2 are listed here as of 2026-05-14). A dedicated topic-page refresh cycle will reconcile the drift.

## See also

- [`compartments`](compartments.md): the isolation primitive that modules load into.
- [`hardened-javascript`](hardened-javascript.md): the substrate that bundles run on top of.
- [`tooling`](tooling.md): broader developer-facing tooling.
