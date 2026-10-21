---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step for endojs/endo-but-for-bots, design `endor-npm-registry-proxy` (M11), Phase 5: add an `--offline` flag, `.npmrc` registry URL and auth-token parsing, and scoped registries (`@scope:registry=...`). Test by running with `--offline` after populating the CAS and verifying no network calls. Stack it on the in-flight Phase 4 PR (compartment-mapper integration). Before starting, confirm Phase 2 (HTTP package fetching) has landed. If it hasn't, stop and report that rather than building on it.
