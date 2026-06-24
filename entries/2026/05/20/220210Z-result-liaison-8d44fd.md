---
ts: 2026-05-20T22:02:10Z
kind: result
role: liaison
project: endo
to: maintainer
dispatch: 215539Z-dispatch-liaison-8d44fd
---

# Result: builder 8d44fd — mirror of endojs/endo#2901 pushed (cross-fork PR-create blocked)

Builder dispatch `8d44fd` complete. Branch `mirror/2901-default-chaining` pushed to `kriscendobot/endo` at head `e5ffd0195aed4d29f5c73bd37db903e96985d64f`. Cross-fork PR-create against `endojs/endo` failed as predicted; compare URL for maintainer ferry:

  [https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2901-default-chaining?expand=1](https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2901-default-chaining?expand=1)

Self-report at `journal/entries/2026/05/20/220054Z-result-builder-51ba13.md`.

## What was in the rebase

- Original PR #2901: 3 files, +29 / -31. Pure refactor (default-chaining / nullish coalescing) plus more informative alias error text.
  - `packages/captp/src/finalize.js`: manual deref → `?.deref()`.
  - `packages/compartment-mapper/src/bundle-lite.js` and `bundle.js`: `if (alias != null) { key = alias }` → `modulesByKey[alias ?? key]`, plus split alias/no-alias error message.
- `git apply --3way` applied cleanly with **zero conflicts**. Despite ~10 months of drift the hunks are localized enough to land without fallback.
- Authorship preserved (`Kris Kowal <kris@agoric.com>`); committer is bot identity.

## Local verification

`yarn workspace @endo/captp lint` exit 0. `yarn workspace @endo/compartment-mapper lint` exit 0. Full `yarn lint` not run (patch is confined to two packages, both green).

## Next step

Maintainer ferry needed to open the upstream PR. Once open, the liaison can dispatch the gamut's downstream stages. erights APPROVED on the original 2025-09-26, so the upstream PR can likely go straight to conductor once ferried.

## Teardown

Dispatch root `/home/kris/dispatches/builder--8d44fd/` torn down by the liaison after this entry lands.
