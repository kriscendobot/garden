Design job complete: `designs/platform-dimension-packages.md` authored on branch `design/platform-dimension-packages` and opened as draft PR endojs/endo-but-for-bots#666 against `llm`.

What I did:

- **Derived the real dimensions from source**, as the brief demanded, and they differ from its guess: `@endo/platform` holds the snapshot fs tier (`src/fs`), its exo facet (`src/exo-fs.js` + `src/fs/interfaces.js`), the Node binding (`src/fs-node`), the extended `Filesystem` capability (`src/fs/extended`, which already carries an internal pure-backend/exo seam from `endo-fs-backend-seam` and self-describes as a future standalone package), a CAS surface smeared across three files in two directories, and `proc`. There is **no net/http dimension in platform**; that pair already shipped as `@endo/http-confine` + `@endo/exo-http-client` and serves as the design's precedent rather than its work.
- **Fixed the endo/exo boundary** as a single rule: interface guards and `makeExo` calls live only in the `exo-` package; `-node` platform bindings may consume exo factories but define none. This entails extracting the stray `makeExo` sites in `snapshot-store.js` and `fs-node/{local-blob,local-tree,tree-writer}.js`, called out per symbol.
- **Specified nine packages plus the umbrella**: `@endo/fs`/`@endo/exo-fs`/`@endo/fs-node`, `@endo/fs-backend`/`@endo/exo-filesystem`, `@endo/cas`/`@endo/cas-node`/`@endo/exo-cas`, `@endo/proc`, with a mermaid dependency graph, per-package contents/dependency tables, scaffolding (package.json shape, tsconfig + composite regeneration, test relocation, separate `chore: Update yarn.lock` commit), and a consumer repoint map covering all thirteen in-repo importers.
- **Compat policy**: moved modules hollow into one-line re-export shims (the file tree keeps its shape, so even the `./fs/extended/*` wildcard keeps resolving); the umbrella is deprecated at birth and its removal reserved for next-major, explicitly reconciled with the `inter-package-plain-re-exports` (#543) repoint→deprecate→remove staging.
- **Execution plan**: one orchestration job over five serial parked children (proc → fs trio → cas trio → extended pair → consumer repoint sweep), `--on-child-failure halt`, repo-wide green gates per child.
- Synced the `designs/README.md` index per project convention (summary table, M3 bucket, per-design estimate, recently-added narration, last-updated line).

Not verified (nothing to run): this is a design-only diff; no build/test surface was touched. The doc, branch, and draft PR #666 existence are verified by the push and `gh pr create` output.

Follow-ups the design names explicitly: the build/orchestration tranche (C1–C5) as a future orchestrated build job; two tracked-as-"to be filed" refactors (digest-power injection to free `@endo/exo-cas` of `node:crypto`, and byte-reader-helper consolidation into `@endo/exo-stream`); and one open question for ferry time (whether the bare names collide with upstream `endojs/endo` plans).

Self-improvement: nothing this time.
