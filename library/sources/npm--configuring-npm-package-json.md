---
source_kind: repo-doc
source_repo: npm/cli
source_path: docs/lib/content/configuring-npm/package-json.md
source_commit: ce7681fe7dbcc20abb5f1379558e14ddd069654f
source_date: 2026-06-18
source_authors: [Max Black, Josh Soref, Michael Smith]
ingested: 2026-07-17
ingested_by: scholar
section_count: 5
status: current
---

Abstract: npm's `package.json` reference (`docs/lib/content/configuring-npm/package-json.md`), the authoritative property catalog for the manifest as the npm CLI consumes it. This is the broadest single source for the field-by-field schema: identity and metadata (name, version, description, keywords, homepage, bugs, license, author/contributors, funding), what ships and how the package is entered (files with its always-included/always-ignored lists, exports/main/type/browser, bin, man, directories, repository), the script-and-native-build fields (scripts, gypfile, config, defaulted values), the full dependency surface with its specifier grammar (dependencies, devDependencies, peerDependencies, peerDependenciesMeta, bundleDependencies, optionalDependencies) plus the two root-only resolution-control fields (overrides, packageExtensions), and the environment-and-publishing fields (engines, os, cpu, libc, devEngines, private, publishConfig, workspaces). Consolidated into five sections per the reference-document convention (`conventions.md` "Sectioning shapes by source type") because the source is an alphabetical property catalog rather than a thematic narrative; each section preserves the source's field anchors inline for grep lookup. This is the primary source for the npm column of the package.json consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [identity-and-metadata](../sections/npm--configuring-npm-package-json--identity-and-metadata.md) | package-manifest, node-packaging | current |
| [files-entry-points-and-bin](../sections/npm--configuring-npm-package-json--files-entry-points-and-bin.md) | package-manifest, node-packaging | current |
| [scripts-config-and-native-build](../sections/npm--configuring-npm-package-json--scripts-config-and-native-build.md) | package-manifest, node-packaging | current |
| [dependencies-and-overrides](../sections/npm--configuring-npm-package-json--dependencies-and-overrides.md) | package-manifest, node-packaging | current |
| [environment-constraints-and-publishing](../sections/npm--configuring-npm-package-json--environment-constraints-and-publishing.md) | package-manifest, node-packaging | current |

Source: [docs/lib/content/configuring-npm/package-json.md](https://github.com/npm/cli/blob/ce7681fe7dbcc20abb5f1379558e14ddd069654f/docs/lib/content/configuring-npm/package-json.md) at commit `ce7681f`.
