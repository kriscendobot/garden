---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job on endojs/endo-but-for-bots (branch off `llm`): implement Phase 2 of the `endor-npm-registry-proxy` design. Phase 2 is the HTTP client that fetches npm packages into the CAS-backed `RegistryTable` in `rust/endo/src/registry.rs`. Phases 1 (the registry table) and 3 (semver selection) are already implemented. Open a DRAFT PR with tests, and update the design's Status section.
