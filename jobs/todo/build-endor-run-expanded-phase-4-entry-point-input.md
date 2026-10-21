---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step for endojs/endo-but-for-bots: implement Phase 4 of designs/endor-run-expanded.md, entry-point module input for `endor run`, using the XS-hosted compartment mapper. Phases 1–3 (CAS ingest, archive, directory input) have landed. In the same change, fix the nested-module-path gap that Phase 3 reported in `ingest_files`, where files nested more than one level are stored under a single slash-joined key.
