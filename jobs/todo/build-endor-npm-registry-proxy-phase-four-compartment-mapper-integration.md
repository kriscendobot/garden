---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step for endojs/endo-but-for-bots, design `endor-npm-registry-proxy` (M11), Phase 4: add a `CasPackageResolver` exposing the `resolvePackage`, `fetchPackageJson`, and `fetchModuleSource` host functions to the XS-hosted compartment mapper, and wire them into its `moduleMapHook` and `importHook`. Stack it on the Phase 2 HTTP-fetch work and the existing Phase 1 and 3 modules, and test with `endor run app.js` importing a registry package.
