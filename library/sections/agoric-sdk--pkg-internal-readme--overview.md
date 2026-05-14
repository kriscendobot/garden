---
title: "@agoric/internal (overview + perpetual-0.y.z policy)"
source: packages/internal/README.md
source_repo: agoric/agoric-sdk
source_commit: 059a66a1ebec72f9f8015ff010fed5fc902ed907
source_date: 2025-09-16
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
notes: The "deep imports only" rule is a bundle-size optimization for downstream `@endo/bundle-source` consumers — without it, importing one helper from internal pulls the whole package. The "may not depend on other repo packages except base-zone/store/cosmic-proto" rule is a hard internal-dependency boundary that contributors must respect.
---

> Abstract: An unsupported in-repo helper package. **NOTE: unsupported** is the first line. The package is deliberately perpetual-0.y.z: per SemVer spec item 4, major version zero means "anything MAY change at any time." Consumers should use deep imports (`@agoric/internal/src/<file>.js`) to avoid pulling the whole module into `@endo/bundle-source` bundles. The package is designed to host modules with **no dependencies** on other agoric-sdk packages, with three allowlisted exceptions: `base-zone`, `store`, `cosmic-proto` (each itself dependency-free within the repo and destined for possible external migration). May not take dependencies on any other agoric-sdk packages. Never exports ambient types.

**NOTE: unsupported**

# Usage

This package contains code that is required by agoric-sdk and not meant to be imported anywhere else.

Like all `@agoric` packages it follows Semantic Versioning. Unlike the others, it will never have a stable API. In terms of [SemVer spec item 4](https://semver.org/#spec-item-4), it will never reach 1.0:

> Major version zero (0.y.z) is for initial development. Anything MAY change at any time. The public API SHOULD NOT be considered stable.

To keep down the size of [@endo/bundle-source](https://github.com/endojs/endo/tree/master/packages/bundle-source) bundles of source that imports from this package, modules that depend upon it should use deep imports (e.g., `import { defineName } from '@agoric/internal/src/js-utils.js';`) rather than importing the entire module.

# Design

It is meant to be a home for modules that have no dependencies on other packages in this repository, except for the following packages that do not theirselves depend upon any other @agoric packages and may be destined for migration elsewhere:

- [base-zone](../base-zone)
- [store](../store)
- [cosmic-proto](../cosmic-proto)

This package may not take dependencies on any others in this repository.

It must never export ambient types.

Source: [packages/internal/README.md](https://github.com/Agoric/agoric-sdk/blob/059a66a1ebec72f9f8015ff010fed5fc902ed907/packages/internal/README.md) at commit `059a66a1`.
