---
title: §command.js (multi-config CLI runner)
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

162-line CLI wrapping `node:child_process.spawn` to launch AVA-via-spawn for each named configuration in `package.json` under `sesAvaConfigs`. §Two-named-pass-through-categories:
- `passThroughFlags`: boolean flags like `-v`, `--verbose`, `--timeout`.
- `passThroughArgOptions`: options with values like `-m <pattern>`, `--match <pattern>`.

§Two-named-filtering-flags: `--only <name>` (or `-o`) and `--exclude <name>` (or `-x`).

§Borrowable-pattern: §multi-config-CLI-as-a-package.json-driven-runner with §filter-by-name + §pass-through-known-flags + §default-run-everything.
