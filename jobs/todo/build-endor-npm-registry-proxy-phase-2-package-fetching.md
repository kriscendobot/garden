---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step for endojs/endo-but-for-bots, following the design `endor-npm-registry-proxy` (milestone M11, Phases 1 and 3 already implemented). Implement Phase 2, package fetching: add a blocking HTTP client and `fetch_package(name, version)` covering the metadata fetch, tarball download, integrity check, CAS extraction and registry table update. Test it by fetching a small, well-known package such as `is-odd` and verifying the CAS contents. Open a DRAFT PR on the `llm` base.
