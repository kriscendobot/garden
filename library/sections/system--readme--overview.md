---
title: Overview — a CommonJS/npm module loader for client and server
source: README.md
source_repo: gutentags/system
source_commit: 91508059e8241a53bb029592a7f0700e37bba513
source_date: 2017-06-27
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [module-loader, html-modules]
status: current
---

Abstract: System is a CommonJS/npm-compatible module system that works both client-side and server-side in Node.js. For browsers it supports refresh-to-reload debugging as well as a Browserify-comparable build step that produces production bundles. Its module loader resolves both module *and resource* locations by module identifier across package boundaries, and it adds support for configuring per-package module translators (text-to-JavaScript-text) and dependency analyzers — the extension mechanism Guten Tag uses to translate HTML modules to JavaScript.

This is a CommonJS/npm compatible module system. It works both client-side and server-side in Node.js. For browsers, it supports refresh-to-reload debugging, as well as a build step comparable to Browserify to produce bundles for production. The System module loader can resolve both module and resource locations by module identifier across package boundaries.

In addition, System adds support for configuring module translators (text to JavaScript text) and dependency analyzers.

Source: [README.md](https://github.com/gutentags/system/blob/91508059e8241a53bb029592a7f0700e37bba513/README.md) at commit `9150805`.
