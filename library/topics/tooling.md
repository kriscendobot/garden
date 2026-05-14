# Topic: tooling

> Abstract: Endo's developer-facing tooling: build, install, package managers, lint, and the assorted single-purpose packages (`where`, `zip`, `lp32`, `base64`, `hex`, `cjs-module-analyzer`, `eslint-plugin`) that round out the development experience. Distinct from the runtime libraries (SES, eventual-send, marshal, etc.) which sit in their own topics.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-get-started--installing](../sections/endo--docs-get-started--installing.md) | endo docs/get-started.md | Node.js + npm/yarn install prerequisites. |
| [endo--pkg-ses-readme--install](../sections/endo--pkg-ses-readme--install.md) | endo packages/ses/README.md | npm/yarn install of @endo/ses; shim auto-loads on import. |
| [endo--pkg-ses-readme--ecosystem-compatibility](../sections/endo--pkg-ses-readme--ecosystem-compatibility.md) | endo packages/ses/README.md | Ecosystem compatibility: what works under SES and known-incompatible patterns. |
| [endo--docs-guide--using-hardenedjs-with-vetted-shims](../sections/endo--docs-guide--using-hardenedjs-with-vetted-shims.md) | endo docs/guide.md | Vetted-shim pattern for environments where the SES shim cannot run directly. |
| [endo--docs-guide--library-compatibility](../sections/endo--docs-guide--library-compatibility.md) | endo docs/guide.md | Library compat from the guide doc perspective. |
| [agoric-sdk--agents--build-test-and-development-commands](../sections/agoric-sdk--agents--build-test-and-development-commands.md) | agoric-sdk AGENTS.md | The canonical command inventory for agoric-sdk: corepack, yarn install/build/test/lint, typecheck, dprint, prepack/postpack. |
| [agoric-sdk--agents--a3p-container-and-proposal-build-notes](../sections/agoric-sdk--agents--a3p-container-and-proposal-build-notes.md) | agoric-sdk AGENTS.md | A3P Docker container build pattern. |
| [agoric-sdk--contributing--overview-platforms-and-toolchain](../sections/agoric-sdk--contributing--overview-platforms-and-toolchain.md) | agoric-sdk CONTRIBUTING.md | Toolchain prerequisites and sanity-check sequence. |
| [agoric-sdk--readme--build](../sections/agoric-sdk--readme--build.md) | agoric-sdk README.md | Build sequence with node_modules layout and yarn workspaces explanation. |
| [agoric-sdk--readme--edit-loop](../sections/agoric-sdk--readme--edit-loop.md) | agoric-sdk README.md | Inner-loop iteration; zoe contract-facet-bundle gotcha. |
| [agoric-sdk--packages-readme--adding-a-new-package](../sections/agoric-sdk--packages-readme--adding-a-new-package.md) | agoric-sdk packages/README.md | Procedure for adding a new package: dir, package.json, lockfile, CI matrix. |

> Note: this topic page is incomplete (41 sections claim `tooling` but only 11 are listed here as of 2026-05-14). A dedicated topic-page refresh cycle will reconcile the drift.

## See also

- [`getting-started`](getting-started.md): the broader tutorial context.
- [`repository-governance`](repository-governance.md): commit conventions, contributing rules.
