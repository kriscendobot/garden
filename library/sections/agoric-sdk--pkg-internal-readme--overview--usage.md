---
title: Usage
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
parent: agoric-sdk--pkg-internal-readme--overview
---

This package contains code that is required by agoric-sdk and not meant to be imported anywhere else.

Like all `@agoric` packages it follows Semantic Versioning. Unlike the others, it will never have a stable API. In terms of [SemVer spec item 4](https://semver.org/#spec-item-4), it will never reach 1.0:

> Major version zero (0.y.z) is for initial development. Anything MAY change at any time. The public API SHOULD NOT be considered stable.

To keep down the size of [@endo/bundle-source](https://github.com/endojs/endo/tree/master/packages/bundle-source) bundles of source that imports from this package, modules that depend upon it should use deep imports (e.g., `import { defineName } from '@agoric/internal/src/js-utils.js';`) rather than importing the entire module.

Source: [packages/internal/README.md](https://github.com/Agoric/agoric-sdk/blob/059a66a1ebec72f9f8015ff010fed5fc902ed907/packages/internal/README.md) at commit `059a66a1`.
