---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T14:51:57Z
---
Completed package-manager layout research for `package-json`.

- Added eight primary-source-backed `package-manifest` sections: Yarn PnP and linkers, Yarn workspace protocol, pnpm symlinked layout, pnpm peer contexts and workspace YAML, plus Bun workspaces and isolated installs.
- Updated the matrix, inconsistencies sections 4 and 9, strategies, and README coverage. The remaining synthesis flags concern bundlers and other explicitly unrelated gaps, not package-manager layout.
- Checked the maintained Yarn Classic source tree; no standalone canonical v1 layout specification was found, so it is recorded only as the legacy hoisted comparison.
- Verified with `library-link-check.sh --changed`; regenerated and landed the sections and topic-count indexes.

Self-improvement: none.
