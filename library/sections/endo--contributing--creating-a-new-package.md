---
title: Creating a new package
source: CONTRIBUTING.md
source_repo: endojs/endo
source_commit: 6ad084a6900b
source_date: 2026-01-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
---

> Abstract: Procedure for adding a new package to the monorepo: directory layout, package.json conventions, the types-index pair, README and CHANGELOG templates. Coding Style sub-section covers the eslint rules; Markdown Style Guide sub-section covers the docs style (em-dash policy, link conventions).

## Creating a new package

Run <code>[scripts/create-package.sh](./scripts/create-package.sh) $name</code>,
then update the resulting README.md, package.json (specifically setting
`description` and [if appropriate] removing `"private": false`), index.js, and
index.test.js files.

### Coding Style

- Prefer `/** @import */` over dynamic `import()` in JSDoc type annotations.
  Use a top-level `/** @import {Foo} from 'bar' */` comment instead of inline
  `{import('bar').Foo}` in `@param`, `@type`, or `@returns` tags.

### Markdown Style Guide

When writing Markdown documentation:

- Wrap lines at 80 to 100 columns for readability in terminal editors.
- Start each sentence on a new line.
  This ensures changes in one sentence do not cascade into the next in diffs.
- Starting sentences on new lines also obviates any question of whether to use
  one or two spaces after a period.

Example:

```markdown
The Endo stack provides a layered solution through four packages.
Each package has a specific role in enabling safe message passing.
Together, they form the foundation of distributed computing.
```

This convention applies to all documentation files including README.md files,
guides in the `docs/` directory, and package-specific documentation.

**Exception:** Release notes in pull request descriptions and GitHub releases
should use long lines (paragraphs joined without manual wrapping), as GitHub
uses a different Markdown flavor for those contexts.


Source: [CONTRIBUTING.md](https://github.com/endojs/endo/blob/6ad084a6900b/CONTRIBUTING.md) at commit `6ad084a6`.
