---
title: Connection to the wider library
source: packages/ses/src/error/console.js
source_repo: endojs/endo
source_branch: master
source_commit: e02b0f66eb44306c3d739e1670114ef24d4202fa
source_date: 2025-01-02
source_authors: [Mark S. Miller]
source_lines: "417-541 (defineCausalConsoleFromLogger + indentAfterAllSeps kludge + filterConsole)"
topics: [hardened-javascript, errors, testing]
status: current
parent: endo--packages-ses-src-error-console-js--causal-console-from-logger-and-filter-console
---

This section is the **canonical worked example of *single-function-logger-adapter + indent-stack management + severity-gated filter*** at the SES error-handling level. Three threads:

1. **The defineCausalConsoleFromLogger AVA adapter** is the canonical *wrap-a-single-function-as-a-VirtualConsole* pattern. Reusable for any test framework whose logging API is a single function (Mocha `console`, Jest, Jasmine, etc.).

2. **The indent-stack management with `group`/`groupEnd`** is the canonical *bracketed-context* pattern. Each group introduces a context level; groupEnd pops it. Reusable for any logger that wants nested-context indentation.

3. **The *horrible kludge* with explicit TODO** is the canonical *acknowledge-the-hack* discipline. Code that needs a workaround should *call it a workaround*, *explain why it exists*, and *invite a future fix*. Cycle 90's track-turns.js *closure-hoisting* and *TODO this is a ridiculously expensive way to attenuate callsites* in cycle 93's tame-v8 share this discipline.
