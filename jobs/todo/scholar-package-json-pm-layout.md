---
role: scholar
---
# Scholar: package-manager LAYOUT internals + remaining PM details (follow-on)

Follow-on to scholar-package-json-package-managers (which library-backed the manifest-side override/peer/publish/packageManager fields for Yarn Berry, pnpm, Bun, Corepack). This job ingests the LAYOUT and remaining details still flagged synthesis in projects/package-json (matrix + inconsistencies sections 4 and 9):

- Yarn Berry PnP: strict-visibility model, `.pnp.cjs` resolver, `.yarnrc.yml` `packageExtensions`, install-modes (node_modules vs pnp vs pnpm linker), the `workspace:*` protocol grammar. Sources: yarnpkg/berry docs `packages/docusaurus/docs/features/{plugnplay,install-modes,workspaces}.mdx`, `configuration/yarnrc` (packageExtensions).
- pnpm: the symlinked `node_modules/.pnpm` content-addressed store (`docs/symlinked-node-modules-structure.md`), `pnpm-workspace.yaml` `packages:` workspaces field + `patchedDependencies` (`docs/pnpm-workspace_yaml.md`), `how-peers-are-resolved.md`.
- Bun: `docs/pm/workspaces.mdx`, `docs/pm/isolated-installs.mdx` (Bun's isolated/strict layout).
- Yarn Classic (v1): its own `resolutions`/hoisting specifics if a canonical source exists.

Add sections under topic `package-manifest`; un-flag the remaining (synthesis) rows in projects/package-json/{property-consumer-matrix,inconsistencies}.md; update the project README coverage status.
