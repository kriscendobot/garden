---
source: README.md
source_repo: gutentags/system
source_commit: 91508059e8241a53bb029592a7f0700e37bba513
source_date: 2017-06-27
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

The README of System (`gutentags/system`), the CommonJS/npm module + resource loader that translates Guten Tag's HTML modules to JavaScript. System runs client- and server-side, supports refresh-to-reload development and a Browserify-comparable `sysjs` bundle build, and resolves both modules and resources by identifier across package boundaries. Its distinguishing feature is a per-package extension mechanism (`analyze`/`translate`) that is how the `gutentag/extension` HTML-to-JS translator plugs in. The document covers the loader's purpose, the three usage/bootstrapping paths (Node `loadSystem`, browser `boot.js`, production bundle), the extension model (translators, analyzers, dependency `introduce`, package-scoped enforcement), and the C.js → Montage Require → System lineage.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/system--readme--overview.md) | module-loader, html-modules | current |
| [usage-and-bootstrapping](../sections/system--readme--usage-and-bootstrapping.md) | module-loader, getting-started | current |
| [extensions-translators-analyzers](../sections/system--readme--extensions-translators-analyzers.md) | module-loader, html-modules | current |
| [history](../sections/system--readme--history.md) | module-loader | current |
