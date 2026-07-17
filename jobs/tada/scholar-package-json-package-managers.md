# scholar-package-json-package-managers — complete

Library-backed how Yarn Berry, pnpm, Bun, and Corepack read package.json, and un-flagged the package-manager synthesis rows in the package-json project report.

- 6 library sources / 10 sections ingested at pinned commits: yarn-berry--manifest-schema (ab0afaf), pnpm--package-json (047db9a), pnpm--settings (0cf4bd3), bun--overrides (16a7269), bun--lifecycle (16a7269), corepack--readme (05bc5f3).
- Topic package-manifest: +10 rows. Concept dependency-overrides: +5 rows + Common-confusions. Two new concepts: package-manager-pinning, lifecycle-script-trust. sources/README +6, keywords +17.
- Project report (README, property-consumer-matrix, inconsistencies) updated: Yarn/pnpm/Bun/packageManager rows de-flagged with citations; corrected pnpm's override block (moved to pnpm-workspace.yaml in v11).
- Follow-on posted: scholar-package-json-pm-layout (PnP/pnpm-store/workspaces layout internals + Yarn Classic v1).
- Integrity gate green (link-check all 6 sources; topics counts + sections index current).

See result entry entries/2026/07/17/144355Z-result-gardener-45400b.md.
