---
title: §Why a `no-shim` entrypoint exists at all
source-slug: endo--packages-eventual-send-src-no-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles
---

§The-`@endo/eventual-send` package has two entrypoints in its `package.json` (not shown here): §the-default-entrypoint installs the shim + §the-`no-shim`-entrypoint expects the global to already be installed. §This-pattern-IS-the-shim-or-not-shim-dispatch.

§When-an-application-aggregates-multiple-libraries-that-each-want-to-install-the-same-shim, §the-application-can-import-the-shim-once + §all-other-imports-use-the-no-shim-entrypoint + §double-installation-is-avoided.

§First-explicit-observation in library of §shim-vs-no-shim-package-entrypoints-as-named-dispatch-shape.
