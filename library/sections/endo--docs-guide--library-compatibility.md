---
title: Library compatibility
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, tooling]
status: current
notes: Overlaps with endo--pkg-ses-readme--ecosystem-compatibility. Kept both.
---

> Abstract: What works and what does not when SES is applied to common JS ecosystem libraries. Overlaps with endo--pkg-ses-readme--ecosystem-compatibility; this version is the docs/-tree counterpart with possibly different examples.

## Library compatibility

Programs running under SES can use `import` or `require()` to import other libraries consisting
only of SES-compatible JavaScript code. This includes a significant part of the NPM registry.

However, many NPM packages use built-in Node.js modules. If used at import time (in their top-level
code), hardened JavaScript code cannot use the package and fails to load at all. If they use the built-in
features at runtime, then the package can load. However, it might fail later when an invoked function
accesses the missing functionality. So some NPM packages are partially compatible;
usable if you don't invoke certain features.

The same is true for NPM packages that use missing globals, or attempt to modify frozen primordials.

The [Endo wiki](https://github.com/endojs/endo/wiki) tracks compatibility reports for NPM packages,
including potential workarounds.


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
