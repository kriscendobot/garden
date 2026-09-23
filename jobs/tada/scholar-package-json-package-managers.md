The job is complete: `jobs/tada/` written, `jobs/doin/` cleared.

## Completion report

Follow-on to `scholar-package-json-schema-and-tooling`. I ingested how Yarn Berry, pnpm, Bun, and Corepack read `package.json` as library sources at pinned commits, and back-filled the package-manager rows that the predecessor left flagged **(synthesis)** in the `package-json` project report.

**Library ingested (6 sources, 10 sections):**
- `yarn-berry--manifest-schema` (yarnpkg/berry `manifest.json` @ `ab0afaf`) — `resolutions`; `dependenciesMeta`/`peerDependenciesMeta`/peer-with-default; `publishConfig`/`installConfig`/`packageManager`.
- `pnpm--package-json` (@ `047db9a`) — the v11 move of the `pnpm` block to `pnpm-workspace.yaml`; engines/runtime fields; `dependenciesMeta.injected`; pnpm `publishConfig`.
- `pnpm--settings` (@ `0cf4bd3`) — `overrides`, `packageExtensions`, `peerDependencyRules`.
- `bun--overrides` (@ `16a7269`) — reads npm `overrides` + Yarn `resolutions`, top-level only.
- `bun--lifecycle` (@ `16a7269`) — `trustedDependencies` / default-secure lifecycle policy.
- `corepack--readme` (@ `05bc5f3`) — `packageManager` field + `devEngines.packageManager`.

**Indexing:** topic `package-manifest` +10 rows; concept `dependency-overrides` +5 rows + a Common-confusions block; two new concepts (`package-manager-pinning`, `lifecycle-script-trust`) + `concepts/README`; `sources/README` +6; `keywords.md` +17.

**Project report:** README, `property-consumer-matrix.md`, `inconsistencies.md` all de-flagged for Yarn/pnpm/Bun/`packageManager` with citations. **Key correction surfaced:** pnpm's override dialect is no longer under a `pnpm` block in `package.json` — since **pnpm v11** it lives in `pnpm-workspace.yaml`.

**Integrity:** `library-link-check --source-slug` passed for all 6; topics counts reconciled + current; sections index current (all 10 sections present).

**Follow-ups:** posted `scholar-package-json-pm-layout` for the deferred layout internals (Yarn PnP + `.yarnrc.yml` packageExtensions + install-modes + `workspace:*`; pnpm symlinked store + `pnpm-workspace.yaml` workspaces + `patchedDependencies` + peer resolution; Bun workspaces/isolated-installs; Yarn Classic v1). The Bun `bun` export condition was already backed by a peer's runtime ingest.

Self-improvement: multi-tool manifest ingests should pre-split *manifest-field* coverage (small, single-doc, doc-backed) from *install-layout* coverage (large, multi-doc) — they draw on different sources and have very different budgets; folding both into one package-managers job forced the mid-cycle split I resolved via the `-pm-layout` follow-on.
