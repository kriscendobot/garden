---
title: @endo/evasive-transform (overview)
source: packages/evasive-transform/README.md
source_repo: endojs/endo
source_commit: a2c32ec9
source_date: 2026-02-25
source_authors: [Zbyszek Tenerowicz]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: Source transform that helps bundled code evade detection or interception by other JS frameworks running in the same realm. Used by bundle-source for the SES-defensive parts of bundle output.

# @endo/evasive-transform

> Source transforms for evading censorship in [SES](https://github.com/endojs/endo/tree/master/packages/ses)-enabled applications

This package provides a function which transforms source code which would otherwise be rejected outright by SES.
The transform is meaning-preserving.

It covers sequences resembling HTML comments and dynamic `import` inside of:
- comments
- strings
- template strings (but not tagged template strings)
- regular expression literals

and additionally covers sequences resembling HTML comments inside of code itself (e.g., `if (a-->b)`).


Source: [packages/evasive-transform/README.md](https://github.com/endojs/endo/blob/a2c32ec9/packages/evasive-transform/README.md) at commit `a2c32ec9`.
