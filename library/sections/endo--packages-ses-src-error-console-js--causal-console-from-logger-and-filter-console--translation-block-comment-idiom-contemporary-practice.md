---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `defineCausalConsoleFromLogger(loggedErrorHandler)(tlogger)` | The *higher-order-adapter-with-config* pattern: configure once, instantiate per logger. |
| `Implement the VirtualConsole API badly` | Honest-naming-of-the-imperfect-shape. The adapter is intentionally a *lossy* implementation; documentation makes the lossiness explicit. |
| `indentAfterAllSeps` *horrible kludge* with TODO | The acknowledge-the-hack discipline; reusable across the corpus. |
| `if (args.length >= 1)` empty-args group special case | The discipline of *don't emit nothing into the log*; only emit when there are args. |
| `arrayPush(indents, ' ') ... arrayPop(indents)` stack management | The standard bracketed-context-via-stack pattern. |
| `filterConsole` severity-gating via `filter.canLog(severity)` | Capability-style filter: the filter is a `(severity) => boolean` function provided by the application. |
| `TODO do something with optional topic string` | Future-work surface in the function signature; parameter present, unused. |
| Three-wrapper composability (logging + causal + filter) | The Unix-pipe shape: each wrapper does one job; compose them via parameter-passing. |
