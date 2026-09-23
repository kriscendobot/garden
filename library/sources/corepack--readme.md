---
source_kind: repo-doc
source_repo: nodejs/corepack
source_path: README.md
source_commit: 05bc5f3df188f135e0924207f378dfa89afc55bf
source_date: 2026-05-15
source_authors: [Antoine du Hamel, Frieder Bluemle, Jonathan Netley, Leonardo Rocha]
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
---

Abstract: Corepack — the zero-runtime-dependency Node.js shim that bridges a project to the package manager it is meant to be used with, letting you use Yarn and pnpm without installing them. It is the consumer of the `packageManager` field: `packageManager` pins one manager at an exact `name@version` (optionally `+hash` for integrity — permitted names `yarn`, `npm`, `pnpm`, or a URL to a `.js`/`.tgz`), and Corepack intercepts `yarn`/`pnpm`/`npm` invocations, downloading and caching the pinned version and refusing to run the wrong manager. It also honors `devEngines.packageManager` (which, unlike `packageManager`, may specify a range and an `onFail` policy) as a validating fallback. Corepack was distributed with Node from 14.19.0 up to (not including) 25.0.0. This backs the `packageManager` / Corepack cells of the property-consumer matrix — the field is read by Corepack (a tooling layer), not by the Node runtime.

| Section | Topics | Status |
|---------|--------|--------|
| [package-manager-field](../sections/corepack--readme--package-manager-field.md) | package-manifest, node-packaging | current |

Source: [README.md](https://github.com/nodejs/corepack/blob/05bc5f3df188f135e0924207f378dfa89afc55bf/README.md) at commit `05bc5f3`.
